require "rails_helper"

RSpec.describe "Admin page", type: :request do
  describe "GET /admin" do
    context "when signed out" do
      it "redirects to the login page with a sign-in prompt" do
        get admin_path
        expect(response).to redirect_to(new_user_session_path)
        follow_redirect!
        expect(response.body).to include("Please sign in to continue.")
      end
    end

    context "when signed in as a customer" do
      let(:user) { create(:user, role: :customer) }

      it "redirects back with a not-authorized alert" do
        sign_in user
        get admin_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform that action.")
      end
    end

    context "when signed in as a staff member" do
      let(:user) { create(:user, role: :staff) }

      it "redirects back with a not-authorized alert" do
        sign_in user
        get admin_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform that action.")
      end
    end

    context "when signed in as an admin" do
      let(:user) { create(:user, role: :admin) }

      it "renders the admin area" do
        sign_in user
        get admin_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Admin area")
      end
    end
  end
end
