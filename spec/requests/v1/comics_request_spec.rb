require 'rails_helper'

RSpec.describe "V1::Comics", simple: true, type: :request do
  let(:comic) { create(:comic) }
  describe "GET /v1/comics" do
    subject(:request) { get v1_comics_path, headers: set_header(comic.user.id) }
    let!(:comics) { create_list(:comic, 10) }
    it "should get comics" do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["comics"].count).to eq 11
    end
  end

  describe "GET /v1/comic" do 
    subject(:request) { get v1_comic_path(comic.id), headers: set_header(comic.user.id) }
    it "should get comic" do 
      comic.update(title: "one")
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["title"]).to eq "one"
    end
  end

  describe "POST /v1/comics" do 
    subject(:request) { post v1_comics_path, params: params, headers: set_header(user.id) }
    let(:user) { create(:user) }
    let(:params) { { comic: { title: "test", volume: 0  } } }

    it "should create comic" do
      expect{ request }.to change(Comic, :count).by(+1)
      expect(response).to have_http_status(:created)
    end

    context "should not create" do
      subject(:request) { post v1_comics_path, params: params }
      it "should be unauthorized" do 
        request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "should not create" do
      let(:params) {{ comic: { title: "", volume: 0  } } }
      it "should be forbidden comic without title" do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH v1,comic" do 
    subject(:request) { patch v1_comic_path(comic.id), params: params, headers: set_header(comic.user.id) }
    let(:params) { { comic: {title: "one" } } }

    it "should update" do 
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["comic"]["title"]).to eq "one"
    end

    context "not update" do
      subject(:request) { patch v1_comic_path(comic.id), params: params, headers: set_header(user.id) }
      let(:user) { create(:user) }
      it "should not be updated by other user" do 
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
    
  end

  describe "DELETE v1/comics" do
    subject(:request) { delete v1_comic_path(comic.id), headers: set_header(comic.user.id) }
    let!(:comic) { create(:comic) }
    context "should destroy" do
      it "should be 204" do
        expect{ request }.to change(Comic, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end

    context "should not destroy" do
      subject(:request) { delete v1_comic_path(comic.id), headers: set_header(user.id) }
      let(:user) { create(:user) }
      it "should be deleted by other user" do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
