class V1::UsersController < ApplicationController
  before_action :authorized, only: [:auto_login, :update]
  def show 
    user = User.find(params[:id])
    render json: user
  end

  def create 
    user = User.new(user_params)
    if user.save
      token = encode_token(user.id)
      render json: user, meta: { token: token }, status: :created, adapter: :json
    else
      render json: { errors: "can't sign up" }, status: :forbidden
    end
  end

  def update 
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user, adapter: :json
    else
      render json: { errors: "can't update users" }, status: :forbidden
    end
  end

  def login 
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      token = encode_token(user.id)
      render json: user, meta: { token: token }, adapter: :json
    else
      render json: { errors: "can't correct email or password"}, status: :forbidden
    end
  end

  def auto_login 
    render json: @current_user, adapter: :json
  end

  private 
  
  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
