# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServicePolicy, type: :policy do
  subject(:policy) { described_class.new(user, service) }

  let(:service) { build(:service) }

  context "with a signed-out user (nil)" do
    let(:user) { nil }

    it { expect(policy.index?).to be_falsy }
    it { expect(policy.show?).to be_falsy }
    it { expect(policy.create?).to be_falsy }
    it { expect(policy.new?).to be_falsy }
    it { expect(policy.update?).to be_falsy }
    it { expect(policy.edit?).to be_falsy }
  end

  context "with a customer" do
    let(:user) { build(:user, role: :customer) }

    it { expect(policy.index?).to be false }
    it { expect(policy.show?).to be false }
    it { expect(policy.create?).to be false }
    it { expect(policy.new?).to be false }
    it { expect(policy.update?).to be false }
    it { expect(policy.edit?).to be false }
  end

  context "with a staff member" do
    let(:user) { build(:user, role: :staff) }

    it { expect(policy.index?).to be false }
    it { expect(policy.show?).to be false }
    it { expect(policy.create?).to be false }
    it { expect(policy.new?).to be false }
    it { expect(policy.update?).to be false }
    it { expect(policy.edit?).to be false }
  end

  context "with an admin" do
    let(:user) { build(:user, role: :admin) }

    it { expect(policy.index?).to be true }
    it { expect(policy.show?).to be true }
    it { expect(policy.create?).to be true }
    it { expect(policy.new?).to be true }
    it { expect(policy.update?).to be true }
    it { expect(policy.edit?).to be true }
  end

  describe "Scope" do
    subject(:scope) { described_class::Scope.new(user, Service).resolve }

    let!(:service1) { create(:service) }
    let!(:service2) { create(:service, active: false) }

    context "with an admin" do
      let(:user) { create(:user, role: :admin) }

      it "returns all services" do
        expect(scope).to contain_exactly(service1, service2)
      end
    end

    context "with a staff member" do
      let(:user) { create(:user, role: :staff) }

      it "returns no services" do
        expect(scope).to be_empty
      end
    end

    context "with a customer" do
      let(:user) { create(:user, role: :customer) }

      it "returns no services" do
        expect(scope).to be_empty
      end
    end

    context "with a signed-out visitor" do
      let(:user) { nil }

      it "returns no services" do
        expect(scope).to be_empty
      end
    end
  end
end
