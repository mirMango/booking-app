# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    sequence(:name) { |n| "Service #{n}" }
    duration_minutes { 30 }
    price_cents { 2500 }
    active { true }
  end
end
