require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "Sign up" do
    it "allows a new user to sign up and redirects to root" do
      expect {
        post user_registration_path, params: {
          user: {
            email: "newuser@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Signed in as newuser@example.com")
    end

    it "re-renders form with 422 unprocessable content on validation failure" do
      post user_registration_path, params: {
        user: {
          email: "invalid",
          password: "123",
          password_confirmation: "456"
        }
      }, headers: { "Accept" => "text/vnd.turbo-stream.html, text/html, application/xhtml+xml" }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("error_explanation")
    end
  end

  describe "Log in" do
    let!(:user) { create(:user, email: "existing@example.com", password: "password123") }

    it "signs the user in and redirects to root" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "password123"
        }
      }

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Signed in as existing@example.com")
      expect(response.body).to include("Sign out")
    end

    it "re-renders the login form with 422 status and error message on failed login" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "wrongpassword"
        }
      }, headers: { "Accept" => "text/vnd.turbo-stream.html, text/html, application/xhtml+xml" }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to match(/Invalid email or password\./i)
    end
  end

  describe "Log out" do
    let!(:user) { create(:user) }

    it "logs the user out and redirects to root" do
      sign_in user
      delete destroy_user_session_path

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Log in")
      expect(response.body).to include("Sign up")
      expect(response.body).not_to include("Signed in as #{user.email}")
    end
  end

  describe "Home page (root route)" do
    context "when signed out" do
      it "displays links to sign up and log in" do
        get root_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Sign up")
        expect(response.body).to include("Log in")
        expect(response.body).not_to include("Sign out")
      end
    end

    context "when signed in" do
      let!(:user) { create(:user, email: "signedin@example.com") }

      it "displays the signed-in user's email and a sign out link" do
        sign_in user
        get root_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Signed in as signedin@example.com")
        expect(response.body).to include("Sign out")
      end
    end
  end
end
