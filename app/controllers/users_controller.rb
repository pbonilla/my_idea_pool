class UsersController < ApplicationController
  def create
    user_form = UserForm.new(permitted_params)
    if(user_form.submit)
      @user = User.new(permitted_params)
      if(@user.save)
        render json: AuthenticationService.new(@user).create_session, status: 201
      else
        render json: { errors: @user.errors }, status: 400
      end
    else
      render json: { errors: user_form.errors }, status: 400
    end
  end

  private

  def permitted_params
    params.permit(:email, :name, :password)
  end
end
