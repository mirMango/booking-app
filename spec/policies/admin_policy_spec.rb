require "rails_helper"

RSpec.describe AdminPolicy, type: :policy do
  subject(:policy) { described_class.new(user, :admin) }

  context "with no user (signed out)" do
    let(:user) { nil }

    it "denies index" do
      expect(policy.index?).to be_falsy
    end
  end

  context "with a customer" do
    let(:user) { build(:user, role: :customer) }

    it "denies index" do
      expect(policy.index?).to be false
    end
  end

  context "with a staff member" do
    let(:user) { build(:user, role: :staff) }

    it "denies index" do
      expect(policy.index?).to be false
    end
  end

  context "with an admin" do
    let(:user) { build(:user, role: :admin) }

    it "permits index" do
      expect(policy.index?).to be true
    end
  end
end
