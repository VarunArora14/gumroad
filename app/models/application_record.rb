# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include StrippedFields
  include AttributeBlockable

  self.abstract_class = true
end
