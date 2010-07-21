require 'spec_helper'

describe User do
  
  def valid_attributes(uniq="")
    {
      :email    => "email#{uniq}@domain.tld",
      :nickname => "nickname#{uniq}",
      :password => "leet1337",
      :password_confirmation => "leet1337"
    }
  end
  
  it "is valid with all required attributes" do
     User.new(valid_attributes).should be_valid
  end

  it "is invalid without nickname" do
    User.new(valid_attributes.except(:nickname)).should_not be_valid
  end
  
  it "is invalid without email address" do
    User.new(valid_attributes.except(:email)).should_not be_valid
  end
  
  it "is invalid without password" do
    User.new(valid_attributes.except(:password)).should_not be_valid
  end
  
  it "is invalid without password_confirmation" do
    User.new(valid_attributes.except(:password_confirmation)).should_not be_valid
  end
  
  it "is invalid without a password of at least 8 characters" do
    # Set in config/initializers/devise.rb
    u = User.new(valid_attributes("2").with(:password => "too1337", :password_confirmation => "too1337"))
    u.should_not be_valid
    u.errors_on(:password).should be_present
    u.errors_on(:password)[0].should match(/too short/)
  end
  
  it "is invalid when nickname is already is use" do
    User.create!(valid_attributes)
    User.new(valid_attributes("2").with(:nickname => "nickname")).should_not be_valid
  end
  
  it "is invalid when email is already is use" do
    User.create!(valid_attributes)
    User.new(valid_attributes("2").with(:email => "email@domain.tld")).should_not be_valid
  end
  
  it "uses the user's nickname as to-param value" do
    u = User.new(valid_attributes.with(:nickname => "paramablenickname"))
    u.to_param.should ==("paramablenickname")
  end
  
  
  
end