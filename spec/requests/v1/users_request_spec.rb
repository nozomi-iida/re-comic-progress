require 'rails_helper'

RSpec.describe "V1::Users", type: :request do

  def encode_token(user_id)
    expires_in = 1.month.from_now.to_i
    payload = { user_id: user_id, exp: expires_in} 
    JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS256")
  end

  def set_header(user_id)
    token = encode_token(user_id)
    return { "Authorization" => "Bearer #{ token }" }
  end

  describe "POST /v1/users" do 
    subject(:request) { post v1_users_path( params: params ) }
    let(:params) { { user: attributes_for(:user) } }
    it "should not sign up" do 
      post v1_users_path( params: { user: attributes_for(:user, password: "111111") } )
      expect(response).to have_http_status(:forbidden)
    end

    it "should sign up" do 
      expect{ request }.to change(User, :count).by(+1)
      expect(response).to have_http_status(:created)
    end
  end

  describe "POST /v1/login" do
    subject(:request) { post v1_login_path( params: params ) }
    let(:params) { { email: "test1@test.com", password: "password" } }
    let!(:user) { create_list(:user, 3) }

    it "should not log in" do
      post v1_login_path( params: { email: "", password: "" } )
      expect(response).to have_http_status(:forbidden)
    end

    it "should log in", :skip => true do 
      request
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /v1/auto_login" do 
    it "'s status should unauthorise" do 
      get v1_auto_login_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "'s status should authorize" do 
      user = create(:user)
      token = encode_token(user.id)
      get v1_auto_login_path, headers: { "Authorization" => "Bearer #{ token }" }
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["user"]["id"]).to eq user.id
    end
  end

  describe "PATCH /v1/users" do
    subject(:request) { patch v1_user_path(user.id), params: params, headers: set_header(user.id) }
    let(:user) { create(:user) }
    let(:params) { { user: { name: "Remi" } } }

    # it "should not edit" do 
    #   user = create(:user)
    #   other_user = create(:user)
    #   patch v1_user_path(other_user.id), params: params, headers: set_header(user.id)
    #   expect(response).to have_http_status(:forbidden)
    # end

    it "should edit" do 
      request
      expect(response).to have_http_status(:ok)
    end
  end
end
