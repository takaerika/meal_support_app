class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    resource.supporter? ? supporter_home_path : root_path
  end
  
  private
  def production?
    Rails.env.production?
  end

  def basic_auth
    user = ENV["BASIC_AUTH_USER"]
    pass = ENV["BASIC_AUTH_PASSWORD"]
    return unless user.present? && pass.present?

    authenticate_or_request_with_http_basic do |u, p|
      ActiveSupport::SecurityUtils.secure_compare(u, user) &
        ActiveSupport::SecurityUtils.secure_compare(p, pass)
    end
  end

  protected
  def configure_permitted_parameters
    keys = %i[first_name last_name role]
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
    devise_parameter_sanitizer.permit(:account_update, keys: keys)
  end
end