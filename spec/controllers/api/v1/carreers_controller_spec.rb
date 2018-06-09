require 'rails_helper'

RSpec.describe Api::V1::CarreersController, type: :controller do
  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      @carreer =FactoryGirl.create :carreer
      get :show, params:{id: @carreer.id}
    end

    it "returns carreer information in a hash" do
      carreer_response = json_response
      expect(carreer_response[:title]).to eql @carreer.title
    end

    it {should respond_with 200}
  end

  describe "GET #index" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      (0...5).each  {FactoryGirl.create :carreer}
      get :index
    end

    it "should return an array" do
      carreer_response = json_response
      expect(carreer_response.length).to eql 5
    end

    it "should have hashes in array" do
      carreer_response = json_response
      expect(carreer_response.first[:title]).to eql Carreer.first.title
    end

    it {should respond_with 200}

  end
  describe "GET #index university" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      @university =FactoryGirl.create :university
      (0...2).each  {FactoryGirl.create :carreer, university_id:@university.id}
      get :index ,params:{university_id: @university.id}
    end

    it "should return an array" do
      carreer_response = json_response
      expect(carreer_response.length).to eql 2
    end

    it "should have carreers from the specific university" do
      carreer_response = json_response
      expect(carreer_response.first[:university_id]).to eql @university.id
    end

    it {should respond_with 200}

  end
end
