# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include StrippedFields
  include AttributeBlockable
  include LockboxAsJson

  self.abstract_class = true
end
