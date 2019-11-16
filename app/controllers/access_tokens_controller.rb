class AccessTokensController < ApplicationController

  before_action :check_current_user_is_logged_in, only: :destroy

  def create
    session_info = AuthenticationService.login?(permitted_params)
    if session_info.present?
      render json: session_info, status: :created
    else
      render json: { errors: "Please use the correct email / password combination" }, status: :unauthorized
    end
  end

  def refresh
    refresh_token = params[:refresh_token]
    if(refresh_token)
      refresh_info = AuthenticationService.refresh_session(refresh_token)
      if refresh_info
        render json: refresh_info
      else
        render json: { errors: "Please provide the refresh token assigned to the user" }, status: :not_found
      end
    else
      render json: { errors: "Please provide a refresh token" }, status: :bad_request
    end
  end

  def destroy
    refresh_token = params[:refresh_token]
    if(refresh_token)
      if UserEncryptionService.new(@current_user).decode_refresh_token == refresh_token
        AuthenticationService.new(@current_user).delete_session
        head :no_content
      else
        render json: { errors: "Please provide the refresh token assigned to the user" }, status: :not_found
      end
    else
      render json: { errors: "Please provide a refresh token" }, status: :bad_request
    end
  end

  private

  def permitted_params
    params.permit(:email, :password)
  end
end
