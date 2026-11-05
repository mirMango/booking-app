class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  private

  # Permit name in addition to the Devise defaults.
  # Role is intentionally omitted: new users are always customers.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  # Permit name when editing the account profile.
  # Role is intentionally omitted: role changes are an admin-only operation.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end
end
