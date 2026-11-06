# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Database seeds" do
  before do
    allow(Rails.env).to receive(:development?).and_return(true)
  end

  it "loads demo accounts idempotently without duplicates or errors" do
    # First seed run
    Rails.application.load_seed

    expect(User.count).to eq(6)
    expect(User.admin.count).to eq(1)
    expect(User.staff.count).to eq(2)
    expect(User.customer.count).to eq(3)

    admin = User.find_by!(email: "admin@example.com")
    expect(admin.name).to eq("Admin User")
    expect(admin).to be_admin

    staff_members = User.staff
    expect(staff_members.pluck(:email)).to contain_exactly("staff1@example.com", "staff2@example.com")

    customers = User.customer
    expect(customers.pluck(:email)).to contain_exactly("customer1@example.com", "customer2@example.com", "customer3@example.com")

    # Second seed run to verify idempotency
    expect { Rails.application.load_seed }.not_to raise_error

    expect(User.count).to eq(6)
    expect(User.admin.count).to eq(1)
    expect(User.staff.count).to eq(2)
    expect(User.customer.count).to eq(3)
  end

  it "does not create demo accounts outside development" do
    allow(Rails.env).to receive(:development?).and_return(false)

    expect { Rails.application.load_seed }.not_to change(User, :count)
  end
end
