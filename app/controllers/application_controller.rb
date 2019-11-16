class ApplicationController < ActionController::Base

  skip_before_action :verify_authenticity_token

  attr_reader :current_user

  def check_current_user_is_logged_in
    auth_status = AuthenticationService.is_session_active?(request.headers['x-access-token'])
    if auth_status[:active]
      @current_user ||= User.find(auth_status[:current_user_id])
    else
      case auth_status[:error]
        when :expired then render json: { errors: "Your session has expired. Please login again or request a new access token"}, status: :unauthorized
        when :missing_valid_argument then render json: { errors: "Invalid Access Token"}, status: :bad_request
      end
    end
  end
end
