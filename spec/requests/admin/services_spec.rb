# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Services", type: :request do
  let(:admin) { create(:user, role: :admin) }
  let(:staff) { create(:user, role: :staff) }
  let(:customer) { create(:user, role: :customer) }
  let!(:service) { create(:service, name: "Haircut", duration_minutes: 30, price_cents: 2500, active: true) }

  describe "Access control" do
    context "when signed out" do
      it "redirects index to login" do
        get admin_services_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects new to login" do
        get new_admin_service_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects create to login" do
        post admin_services_path, params: { service: { name: "New" } }
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects edit to login" do
        get edit_admin_service_path(service)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects update to login" do
        patch admin_service_path(service), params: { service: { name: "Updated" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as a customer" do
      before { sign_in customer }

      it "refuses index and redirects with alert" do
        get admin_services_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform that action.")
      end

      it "refuses create and redirects with alert" do
        post admin_services_path, params: { service: { name: "Unauthorized" } }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform that action.")
      end
    end

    context "when signed in as staff" do
      before { sign_in staff }

      it "refuses index and redirects with alert" do
        get admin_services_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform that action.")
      end

      it "refuses edit and redirects with alert" do
        get edit_admin_service_path(service)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform that action.")
      end
    end
  end

  describe "Admin operations" do
    before { sign_in admin }

    describe "GET /admin/services" do
      it "renders the services list with decimal price and status" do
        get admin_services_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Haircut")
        expect(response.body).to include("30 mins")
        expect(response.body).to include("$25.00")
        expect(response.body).to include("Active")
        expect(response.body).to include("New Service")
      end
    end

    describe "GET /admin/services/new" do
      it "renders the new service form" do
        get new_admin_service_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("New Service")
      end
    end

    describe "POST /admin/services" do
      context "with valid parameters" do
        it "creates a service with decimal price converted to cents and redirects" do
          expect {
            post admin_services_path, params: {
              service: {
                name: "Beard Trim",
                duration_minutes: 20,
                price: "18.50",
                active: "1"
              }
            }
          }.to change(Service, :count).by(1)

          expect(response).to redirect_to(admin_services_path)
          follow_redirect!
          expect(response.body).to include("Service was successfully created.")

          created = Service.find_by!(name: "Beard Trim")
          expect(created.duration_minutes).to eq(20)
          expect(created.price_cents).to eq(1850)
          expect(created.price).to eq(18.5)
          expect(created.active).to be true
        end
      end

      context "with invalid parameters" do
        it "does not create a service and re-renders new form with 422 and errors" do
          expect {
            post admin_services_path, params: {
              service: {
                name: "",
                duration_minutes: 0,
                price: "-5.00",
                active: "1"
              }
            }
          }.not_to change(Service, :count)

          expect(response).to have_http_status(:unprocessable_content)
          expect(response.body).to include("error_explanation")
        end
      end
    end

    describe "GET /admin/services/:id/edit" do
      it "renders the edit form with current values" do
        get edit_admin_service_path(service)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Edit Service")
        expect(response.body).to include("Haircut")
        expect(response.body).to include("25.00")
      end
    end

    describe "PATCH /admin/services/:id" do
      context "with valid parameters" do
        it "updates service attributes and redirects" do
          patch admin_service_path(service), params: {
            service: {
              name: "Deluxe Haircut",
              duration_minutes: 45,
              price: "35.00",
              active: "1"
            }
          }

          expect(response).to redirect_to(admin_services_path)
          service.reload
          expect(service.name).to eq("Deluxe Haircut")
          expect(service.duration_minutes).to eq(45)
          expect(service.price_cents).to eq(3500)
        end

        it "deactivates the service by unchecking active" do
          expect(service.active).to be true

          patch admin_service_path(service), params: {
            service: {
              name: service.name,
              duration_minutes: service.duration_minutes,
              price: service.formatted_price,
              active: "0"
            }
          }

          expect(response).to redirect_to(admin_services_path)
          service.reload
          expect(service.active).to be false
        end
      end

      context "with invalid parameters" do
        it "re-renders the edit form with 422 and errors" do
          patch admin_service_path(service), params: {
            service: {
              name: "",
              duration_minutes: -10,
              price: ""
            }
          }

          expect(response).to have_http_status(:unprocessable_content)
          expect(response.body).to include("error_explanation")
        end
      end
    end
  end

  describe "Admin dashboard link" do
    before { sign_in admin }

    it "links to the services management page from /admin" do
      get admin_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(admin_services_path)
      expect(response.body).to include("Manage Services")
    end
  end
end
