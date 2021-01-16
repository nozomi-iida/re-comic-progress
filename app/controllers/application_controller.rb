class ApplicationController < ActionController::API

  def encode_token(user_id)
    expires_in = 1.month.from_now.to_i
    payload = { user_id: user_id, exp: expires_in} 
    JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS256")
  end

  def decoded_token
    if request.headers["authorization"]
      begin
        token = request.headers["authorization"].split(" ")[1]
        JWT.decode(token, Rails.application.secrets.secret_key_base, "HS256")
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]["user_id"]
      @current_user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: "Please log in"}, status: :unauthorized unless logged_in?
  end

end
