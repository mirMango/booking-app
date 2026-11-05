class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Raise if any controller action forgets to call authorize.
  # Individual controllers or actions can skip this with skip_after_action :verify_authorized.
  after_action :verify_authorized, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :handle_not_authorized

  private

  def handle_not_authorized
    if user_signed_in?
      redirect_back fallback_location: root_path, alert: "You are not authorized to perform that action."
    else
      redirect_to new_user_session_path, alert: "Please sign in to continue."
    end
  end
end
