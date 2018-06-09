class Api::V1::SessionsController < ApplicationController

  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email].downcase
    if user_email.present?
      user =  User.find_by(email: user_email)
      if user
        if user.valid_password? user_password
          sign_in user, store: false
          # user.generate_authentication_token!
          # user.save
          render json:user,status: 200, location: [:api, user]
        else
          render json: { errors: {password:"Invalid password"} }, status: 401
        end
      else
        render json: { errors: {email:"Invalid email" }}, status: 401
      end

    else
        render json: { errors: {email:"You must supply email" ,password: "You must supply password"}}, status: 401
    end
  end

  # DEPRECATED
  def destroy
    user = User.find_by(auth_token: request.headers['Authorization'])
    if user
      #user.generate_authentication_token!
      #user.save
      head 204
    else
      head 401
    end

  end

end
