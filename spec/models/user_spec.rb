require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(name: "Example User", email: "user@example.com", password: "111111", password_confirmation: "111111") }
  it "should be valid" do
    expect(user.valid?).to eq true
  end

  it "should be invalid without name" do
    user.name = " "
    expect(user.valid?).to be false
  end

  it "should be invalid without email" do
    user.email = " "
    expect(user.valid?).to be false
  end

  it "should be invalid when name be too long" do 
    user.name = "a" * 51
    expect(user.valid?).to be false
  end

  it "should be invalid when email be too long" do 
    user.email = "a" * 244 + "@example.com"
    expect(user.valid?).to be false
  end

  it "should be invalid when email validation accept valid addresses" do
    #%w can make array from string.
    valid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user.valid?).to be false
    end
  end

  it "should be invalid when email is not unique" do 
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user.valid?).to be false
  end

  it ".email should be saves as lower-case" do 
    mixed_case_email = "Foo@ExAMPle.CoM"
    user.email = mixed_case_email
    user.save
    expect(mixed_case_email.downcase).to eq user.reload.email
  end

  it "should be invalid when password is blank" do 
    user.password = user.password_confirmation = "" * 6
    expect(user.valid?).to be false
  end

  it "should be invalid when password is too short" do 
    user.password = user.password_confirmation = "" * 5
    expect(user.valid?).to be false
  end

  it "should return false without token" do 
    expect(user.digest?(:activation, "")).to be false
  end
end
