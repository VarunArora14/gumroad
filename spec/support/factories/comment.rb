# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    association :commentable, factory: :user
    content { "MyText" }
    author
  end
end
