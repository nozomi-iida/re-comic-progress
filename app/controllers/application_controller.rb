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

  def current_user
    if decoded_token
      if @current_user.nil? 
        user_id = decoded_token[0]["user_id"]
        User.find_by(id: user_id)
      else
        @current_use
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

end
