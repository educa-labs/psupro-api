require 'rails_helper'

RSpec.describe Api::V1::UniversitiesController, type: :controller do

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      @university =FactoryGirl.create :university
      get :show, params:{id: @university.id}
    end

    it "returns university information in a hash" do
      university_response = json_response
      expect(university_response[:motto]).to eql @university.motto
    end

    it "should hava a nested institution" do
      university_response = json_response
      expect(university_response[:institution][:title]).to eql @university.institution.title
    end

    it {should respond_with 200}
  end

  describe "GET #index" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      (0...5).each  {FactoryGirl.create :university}
      get :index
    end

    it "should return an array" do
      university_response = json_response
      expect(university_response.length).to eql 5
    end

    it "should have hashes in array" do
      university_response = json_response
      expect(university_response.first[:motto]).to eql University.first.motto
    end

    it {should respond_with 200}

  end

end
