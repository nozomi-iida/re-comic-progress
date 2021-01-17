require 'rails_helper'

RSpec.describe "V1::PasswordResets", type: :request do
  before do 
    ActionMailer::Base.deliveries.clear
  end

  def create_reset_digest_user(user)
    user.create_reset_digest
    user
  end

  describe "POST /v1/password_resets" do 
    let!(:user) { create(:user) }
    subject(:request) { post v1_password_resets_path, params: params }
    let(:params) { { "password_reset": { email: user.email } } }

    it "should send email" do 
      request
      expect(response).to have_http_status(:ok)
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    it "should not send email" do 
      post v1_password_resets_path, params: { password_reset: { email: "test3@test.com" } } 
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /v1/password_resets/:id" do 
    subject(:request) { patch v1_password_reset_url(reset_digest_user.reset_token), params: params }
    let(:params) { { 
      email: user.email,
      user: {
        password: password, 
        password_confirmation: "111111" 
      } 
    } }
    let(:reset_digest_user) { create_reset_digest_user(user) }
    let(:user) { create(:user) }
    let(:password) { "111111" }

    context "should not update" do 
      let(:password) { " " }
      it "should be forbidden when password is blank" do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "should not update" do 
      let(:password) { "1" }
      it "should be forbidden when invalid password" do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "should not update" do 
      it "shoud be forbidden when user is unactivated" do
        reset_digest_user.update(activated: false)
        request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "should not update" do 
      it "shoud be forbidden when time expired" do
        reset_digest_user.update(reset_sent_at: 3.hours.ago)
        request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "should update" do 
      it "should be ok" do
        request
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
