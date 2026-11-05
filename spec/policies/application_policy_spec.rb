require "rails_helper"

RSpec.describe ApplicationPolicy, type: :policy do
  subject(:policy) { described_class.new(user, record) }

  let(:record) { double("record") }

  context "with no user (signed out)" do
    let(:user) { nil }

    it { expect(policy.index?).to be false }
    it { expect(policy.show?).to be false }
    it { expect(policy.create?).to be false }
    it { expect(policy.new?).to be false }
    it { expect(policy.update?).to be false }
    it { expect(policy.edit?).to be false }
    it { expect(policy.destroy?).to be false }
  end

  context "with a customer" do
    let(:user) { build(:user, role: :customer) }

    it { expect(policy.index?).to be false }
    it { expect(policy.show?).to be false }
    it { expect(policy.create?).to be false }
    it { expect(policy.update?).to be false }
    it { expect(policy.destroy?).to be false }
  end

  context "with a staff member" do
    let(:user) { build(:user, role: :staff) }

    it { expect(policy.index?).to be false }
    it { expect(policy.show?).to be false }
    it { expect(policy.create?).to be false }
    it { expect(policy.update?).to be false }
    it { expect(policy.destroy?).to be false }
  end

  context "with an admin" do
    let(:user) { build(:user, role: :admin) }

    it { expect(policy.index?).to be false }
    it { expect(policy.show?).to be false }
    it { expect(policy.create?).to be false }
    it { expect(policy.update?).to be false }
    it { expect(policy.destroy?).to be false }
  end
end
