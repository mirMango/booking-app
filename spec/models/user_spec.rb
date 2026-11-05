require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with a valid email and password" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "requires an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "requires a valid email format" do
      user = build(:user, email: "invalid-email")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "enforces unique emails (case-insensitive)" do
      create(:user, email: "test@example.com")
      duplicate = build(:user, email: "TEST@example.com")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to be_present
    end

    it "requires a password" do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it "requires password length to be at least 6 characters" do
      user = build(:user, password: "12345", password_confirmation: "12345")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it "requires password and password confirmation to match" do
      user = build(:user, password: "password123", password_confirmation: "different")
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to be_present
    end
  end
end
