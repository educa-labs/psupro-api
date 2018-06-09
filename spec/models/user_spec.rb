require 'rails_helper'
require 'shoulda-matchers'

RSpec.describe User, type: :model do
  before {@user = FactoryGirl.build(:user)}
  subject{@user}

  it 'should be responsive' do
    expect(subject).to respond_to(:email, :password, :password_confirmation)
  end

  it 'should be valid' do
    expect(subject).to be_valid
  end

  it 'should validate email' do
    expect(subject).to validate_presence_of(:email)
  end

  it { should respond_to(:auth_token) }
  it { should validate_uniqueness_of(:auth_token)}

  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      Devise.stub(:friendly_token).and_return("elpulento_token")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "elpulento_token"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "elpulento_token")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end


end

