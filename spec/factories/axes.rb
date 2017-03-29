# frozen_string_literal: true

FactoryGirl.define do
  factory :axis, class: Axis do
    sequence(:title) { |n| "Axe #{n}" }
  end
end
