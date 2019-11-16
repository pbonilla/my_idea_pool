class AuthController < ApplicationController
  before_action :check_current_user_is_logged_in

  # This action should return the current user information if the user is logged in
  def me
    render :show, status: :ok
  end
end
