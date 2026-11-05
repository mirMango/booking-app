require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with a valid name, email, and password" do
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

    it "requires a name" do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end

    it "rejects a blank name" do
      user = build(:user, name: "")
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end
  end

  describe "role enum" do
    it "defaults to customer" do
      user = create(:user)
      expect(user).to be_customer
      expect(user.role).to eq("customer")
    end

    it "supports all three roles" do
      expect(User.roles.keys).to contain_exactly("customer", "staff", "admin")
    end

    it "can be assigned staff role" do
      user = create(:user, role: :staff)
      expect(user).to be_staff
    end

    it "can be assigned admin role" do
      user = create(:user, role: :admin)
      expect(user).to be_admin
    end

    it "rejects an invalid role value on save" do
      user = build(:user, role: :superuser)
      expect(user).not_to be_valid
      expect(user.errors[:role]).to be_present
    end
  end
end
