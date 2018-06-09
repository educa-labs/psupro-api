require 'rails_helper'
require 'request_helpers'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      get :show, params:{id: @user.id}
    end

    it "returns user information in a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it {should respond_with 200}
  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        city = FactoryGirl.create(:city)
        level = FactoryGirl.create(:level)
        institution = FactoryGirl.create(:institution)
        @user_attributes["city_id"] = city.id
        @user_attributes["level_id"] = level.id
        @user_attributes["institution_id"] =institution.id
        post :create, params: { user: @user_attributes }
      end

      it "returns json for the user record created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "123456789" }
        post :create, params:{ user: @invalid_user_attributes }
      end

      it "returns a json with errors key" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "returns a json with error details" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
        expect(user_response[:errors][:password_confirmation]).to include "doesn't match Password"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do

    context "when is successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        patch :update, params:{ id: @user,
                         user: { email: "hu3hu3@educalabs.cl" }}

      end

      it "returns json representation with the updated data" do
        user_response = json_response
        expect(user_response[:email]).to eql "hu3hu3@educalabs.cl"
      end

      it { should respond_with 200 }
    end

    context "when input is wrong" do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        patch :update, params:{ id: @user.id,
                         user: { email: "jajasaludos" } }

      end

      it "returns errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "returns json on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      delete :destroy, params: { id: @user.auth_token }

    end

    it { should respond_with 204 }
  end
end
