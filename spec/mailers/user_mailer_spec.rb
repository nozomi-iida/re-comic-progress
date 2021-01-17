require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(user) }
    let(:user) { build(:user, activation_token: User.new_token) }

    it "renders the headers" do
      expect(mail.subject).to eq(mail.subject)
      expect(mail.to).to eq(mail.to)
      expect(mail.from).to eq(mail.from)
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(CGI.escape(user.email))
      expect(mail.body.encoded).to match(user.activation_token)
    end
  end

  # describe "password_reset" do
  #   let(:mail) { UserMailer.password_reset }

  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Password reset")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["iida19990106@gmail.com"])
  #   end

  #   it "renders the body" do
  #     expect(mail.body.encoded).to match("Hi")
  #   end
  # end

end
