require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe "POST #create" do

    before(:each) do
      @user = FactoryGirl.create :user
    end
    #TODO: Enable this tests by rolling back devise to 4.1.1 or wait for a bug fix https://github.com/plataformatec/devise/issues/4189
    # context "when the credentials are correct" do
    #
    #   before(:each) do
    #     credentials = { email: @user.email, password: @user.password }
    #     post :create, params:{ session: credentials }
    #   end
    #
    #   it "returns the user record corresponding to the given credentials" do
    #     @user.reload
    #     expect(json_response[:auth_token]).to eql @user.auth_token
    #   end
    #
    #   it { should respond_with 200 }
    # end

    context "when the credentials are incorrect" do

      before(:each) do
        credentials = { email: @user.email, password: "invalidpassword" }
        post :create, params:{ session: credentials }
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eql "Invalid password"
      end

      it { should respond_with 401 }
    end
    #
    # describe "DELETE #destroy" do
    #
    #   before(:each) do
    #     @user = FactoryGirl.create :user
    #     sign_in @user, store: false
    #     delete :destroy, auth_token: @user.auth_token
    #   end
    #
    #   it { should respond_with 204 }
    #
    # end

  end
end
