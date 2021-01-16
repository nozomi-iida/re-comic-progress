require 'rails_helper'

RSpec.describe "V1::Users", type: :request do
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
end
