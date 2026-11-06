# frozen_string_literal: true

# Demo password for development accounts only.
DEMO_PASSWORD = "password123" unless defined?(DEMO_PASSWORD)

# Demo accounts must never be created in production.
if Rails.env.development?
  demo_users = [
    { name: "Admin User", email: "admin@example.com", role: :admin },
    { name: "Staff Member One", email: "staff1@example.com", role: :staff },
    { name: "Staff Member Two", email: "staff2@example.com", role: :staff },
    { name: "Customer One", email: "customer1@example.com", role: :customer },
    { name: "Customer Two", email: "customer2@example.com", role: :customer },
    { name: "Customer Three", email: "customer3@example.com", role: :customer }
  ]

  demo_users.each do |attrs|
    User.find_or_create_by!(email: attrs[:email]) do |user|
      user.name = attrs[:name]
      user.password = DEMO_PASSWORD
      user.password_confirmation = DEMO_PASSWORD
      user.role = attrs[:role]
    end
  end
end
