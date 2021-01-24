require 'rails_helper'

RSpec.describe Comic, type: :model do
  subject(:comic) { user.comics.build(title: "test", volume: 1, user_id: user.id) }
  let(:user) { create(:user) }

  describe "validate comic" do 
    it "should be valid" do 
      expect(comic.valid?).to be true
    end
  
    it "should be invalid without user_id" do 
      comic.user_id = nil
      expect(comic.valid?).to be false
    end
  
    it "should be invalid without title" do 
      comic.title = " "
      expect(comic.valid?).to be false
    end

    it "should be most recent first" do 
      comics = create_list(:comic, 5)
      latest_comic =  create(:latest_comic)
      expect(latest_comic).to eq Comic.first
    end
  end

end
