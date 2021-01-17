class V1::PasswordResetsController < ApplicationController
  before_action :get_user, only: [:update]
  before_action :valid_user, only: [:update]
  before_action :check_expiration, only: [:update]

  def create 
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_mail
      render json: { message: "send email" }
    else
      render json: { error: "can't find user" }, status: :forbidden
    end
  end

  def update
    if params[:user][:password].empty?
      render json: { error: "can't update password" }, status: :forbidden
    elsif @user.update(user_params)
      render json: @user, adapter: :json
    else
      render json: { error: "can't update password" }, status: :forbidden
    end
  end

  private 

  def user_params 
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user 
    @user = User.find_by(email: params[:email])
  end

  def valid_user 
    unless (@user && @user.activated? && @user.digest?(:reset, params[:id]))
      render json: { error: "user is invalid" }, status: :forbidden
    end
  end

  def check_expiration 
    if @user.password_reset_expired?
      render json: { error: "password is expiration" }, status: :forbidden
    end
  end
end
