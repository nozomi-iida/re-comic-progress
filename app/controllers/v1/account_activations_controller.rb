class V1::AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.digest?(:activation, params[:id])
      user.activate
      token = encode_token(user.id)
      render json: user, meta: { token: token }, status: :created, adapter: :json
    else
      render json: { error: "can't activate" }, status: :forbidden
    end
  end
end
