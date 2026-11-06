# frozen_string_literal: true

require "rails_helper"

RSpec.describe Service, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      service = build(:service)
      expect(service).to be_valid
    end

    it "requires a name" do
      service = build(:service, name: nil)
      expect(service).not_to be_valid
      expect(service.errors[:name]).to be_present
    end

    it "requires duration_minutes to be present" do
      service = build(:service, duration_minutes: nil)
      expect(service).not_to be_valid
      expect(service.errors[:duration_minutes]).to be_present
    end

    it "requires duration_minutes to be greater than 0" do
      expect(build(:service, duration_minutes: 0)).not_to be_valid
      expect(build(:service, duration_minutes: -10)).not_to be_valid
      expect(build(:service, duration_minutes: 15)).to be_valid
    end

    it "requires duration_minutes to be an integer" do
      expect(build(:service, duration_minutes: 15.5)).not_to be_valid
    end

    it "requires price_cents to be present" do
      service = build(:service, price_cents: nil)
      expect(service).not_to be_valid
      expect(service.errors[:price_cents]).to be_present
    end

    it "allows price_cents to be 0 or greater" do
      expect(build(:service, price_cents: 0)).to be_valid
      expect(build(:service, price_cents: 1500)).to be_valid
      expect(build(:service, price_cents: -1)).not_to be_valid
    end

    it "requires price_cents to be an integer" do
      expect(build(:service, price_cents: 25.5)).not_to be_valid
    end

    it "requires active to be true or false" do
      expect(build(:service, active: true)).to be_valid
      expect(build(:service, active: false)).to be_valid
      expect(build(:service, active: nil)).not_to be_valid
    end
  end

  describe "price decimal conversion" do
    it "converts cents to decimal price" do
      service = build(:service, price_cents: 2550)
      expect(service.price).to eq(25.5)
      expect(service.formatted_price).to eq("25.50")
      expect(service.display_price).to eq("$25.50")
    end

    it "converts decimal string to integer cents" do
      service = build(:service)
      service.price = "49.99"
      expect(service.price_cents).to eq(4999)
      expect(service.formatted_price).to eq("49.99")
    end

    it "handles numeric input for price=" do
      service = build(:service)
      service.price = 15
      expect(service.price_cents).to eq(1500)
    end

    it "handles blank input for price=" do
      service = build(:service)
      service.price = ""
      expect(service.price_cents).to be_nil
    end

    it "handles invalid string input for price=" do
      service = build(:service)
      service.price = "invalid"
      expect(service.price_cents).to be_nil
    end
  end

  describe "database-level constraints" do
    it "enforces positive duration_minutes check constraint" do
      service = build(:service)
      expect {
        service.save(validate: false)
        ActiveRecord::Base.connection.execute("UPDATE services SET duration_minutes = 0 WHERE id = #{service.id}")
      }.to raise_error(ActiveRecord::StatementInvalid, /services_duration_minutes_positive/)
    end

    it "enforces non-negative price_cents check constraint" do
      service = build(:service)
      expect {
        service.save(validate: false)
        ActiveRecord::Base.connection.execute("UPDATE services SET price_cents = -50 WHERE id = #{service.id}")
      }.to raise_error(ActiveRecord::StatementInvalid, /services_price_cents_non_negative/)
    end
  end
end
