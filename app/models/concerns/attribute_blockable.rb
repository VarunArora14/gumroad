# frozen_string_literal: true

module AttributeBlockable
  extend ActiveSupport::Concern

  included do
    attribute :blocked_by_attributes, :json, default: {}
  end

  module RelationMethods
    def with_blocked_attributes_for(*method_names)
      spawn.tap { |relation| relation.extending!(BlockedAttributesPreloader.new(*method_names)) }
    end
  end

  class BlockedAttributesPreloader < Module
    def initialize(*method_names)
      @method_names = Array.wrap(method_names).map(&:to_s)
      super()
    end

    def extended(relation)
      add_method_to_preload_list(relation)
      override_exec_queries(relation)
      define_preloading_methods(relation)
      relation
    end

    private
      def add_method_to_preload_list(relation)
        existing_methods = relation.instance_variable_get(:@_blocked_attributes_methods) || Set.new
        relation.instance_variable_set(:@_blocked_attributes_methods, Set.new(existing_methods + @method_names))
      end

      def override_exec_queries(relation)
        relation.define_singleton_method(:exec_queries) do |&block|
          @records = super(&block)
          preload_blocked_attributes! unless relation.instance_variable_get(:@_blocked_attributes_preloaded)
          @records
        end
      end

      def define_preloading_methods(relation)
        relation.define_singleton_method(:preload_blocked_attributes!) do
          return if @records.blank?

          (@_blocked_attributes_methods || Set.new).each do |method_name|
            preload_blocked_attribute_for_method(method_name)
          end

          relation.instance_variable_set(:@_blocked_attributes_preloaded, true)
        end

        relation.define_singleton_method(:preload_blocked_attribute_for_method) do |method_name|
          values = @records.filter_map { |record| record.try(method_name).presence }.uniq
          return if values.empty?

          scope = BLOCKED_OBJECT_TYPES.fetch(method_name.to_sym, :all)
          blocked_objects_by_value = BlockedObject.send(scope).find_active_objects(values).index_by(&:object_value)

          @records.each do |record|
            value = record.send(method_name)
            blocked_object = blocked_objects_by_value[value]
            record.blocked_by_attributes[method_name] = blocked_object&.blocked_at
          end
        end
      end
  end

  class_methods do
    def attr_blockable(blockable_method, attribute: nil)
      attribute ||= blockable_method
      define_method("#{blockable_method}_blocked_at?") { blocked_at_by_method(attribute, blockable_method:).present? }
      define_method("#{blockable_method}_blocked?") { blocked_at_by_method(attribute, blockable_method:).present? }
      define_method("#{blockable_method}_blocked_at") { blocked_at_by_method(attribute, blockable_method:) }
    end

    def with_blocked_attributes_for(*method_names)
      all.extending(RelationMethods).with_blocked_attributes_for(*method_names)
    end
  end

  def blocked_at_by_method(method_name, blockable_method: nil)
    blockable_method ||= method_name
    method_key = blockable_method.to_s

    return blocked_by_attributes[method_key] if blocked_by_attributes.key?(method_key)

    value = send(blockable_method)
    return if value.blank?

    blocked_at = lookup_blocked_object_for_value(method_name, value)
    blocked_by_attributes[method_key] = blocked_at
    blocked_at
  end

  private

  def lookup_blocked_object_for_value(method_name, value)
    scope = BLOCKED_OBJECT_TYPES.fetch(method_name.to_sym, :all)
    BlockedObject.send(scope).find_active_object(value)&.blocked_at
  end
end
