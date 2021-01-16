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

  describe "GET /v1/users" do
    subject(:request) { get v1_users_path, headers: set_header(user.id) }
    let(:user) { create(:user) }
    let!(:users) { create_list(:user, 10) } 

    it "should not view" do 
      get v1_users_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "should view" do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["users"].count).to eq 11
    end
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

    it "should edit" do 
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["user"]["name"]).to eq("Remi")
    end

    it "should not edit with invalid email" do 
      user = create(:user)
      patch v1_user_path(user.id), params: { user: { email: "test@invalid" } }, headers: set_header(user.id)
      expect(response).to have_http_status(:forbidden)
    end

    it "should not edit with different" do
      user = create(:user)
      other_user = create(:user)
      patch v1_user_path(other_user.id), params: { user: { email: "test@invalid" } }, headers: set_header(user.id)
      expect(response).to have_http_status(:forbidden)
    end

    it "should not edit admin" do
      user = create(:user)
      patch v1_user_path(user.id), params: { user: { admin: true } }, headers: set_header(user.id)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["user"]["admin"]).to eq(false)
    end
  end

  describe "DELETE v1/user" do 
    it "should destroy" do
      admin_user = create(:admin_user)
      user = create(:user)
      expect { delete v1_user_path(user.id), headers: set_header(admin_user.id) }.to change(User, :count).by(-1)
      expect(response).to have_http_status(204)
    end

    it "should not destroy" do
      user = create(:user)
      delete v1_user_path(user.id)
      expect(response).to have_http_status(:unauthorized)
    end

    it "should not destroy with not admin" do 
      user = create(:user)
      delete v1_user_path(user.id), headers: set_header(user.id)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
