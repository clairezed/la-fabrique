# frozen_string_literal: true

FactoryGirl.define do
  factory :admin do
    email 'technique@studio-hb.com'
    password 'password'
    password_confirmation 'password'
  end
end
