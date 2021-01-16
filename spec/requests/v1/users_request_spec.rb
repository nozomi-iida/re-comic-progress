require 'rails_helper'

RSpec.describe "V1::Users", type: :request do
  describe "POST /v1/users" do 
    subject(:request) { post v1_users_path( params: params ) }
    let(:params) { { user: attributes_for(:user) } }
    it "should invalid sign up" do 
      post v1_users_path( params: { user: attributes_for(:user, password: "111111") } )
      expect(response).to have_http_status(:forbidden)
    end

    it "should valid sign up" do 
      expect{ request }.to change(User, :count).by(+1)
      expect(response).to have_http_status(:created)
    end
  end
end
