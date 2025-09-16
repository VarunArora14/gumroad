# frozen_string_literal: true

module User::CustomFee
  extend ActiveSupport::Concern
  include JsonData

  included do
    attr_json_data_accessor :custom_fee_per_thousand

    validates :custom_fee_per_thousand, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }
  end

  def custom_fee_percent
    custom_fee_per_thousand.presence && (custom_fee_per_thousand / 10.0).round(1)
  end

  # update custom_fee_percent does not update custom_fee_per_thousand. # fix this.
  def custom_fee_percent=(value)
    self.custom_fee_per_thousand = value.presence && (value.to_f * 10).round
  end
end
