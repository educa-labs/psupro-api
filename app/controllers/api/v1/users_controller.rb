class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:show,:update, :destroy]
  respond_to :json

  def create
    user_hash = clear_params
    user = User.new(user_hash)
    if user.save
      user.generate_authentication_token!
      user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = current_user
    user_hash= clear_params
    if user.update(user_hash)
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    current_user.destroy
    head 204
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,:first_name,:last_name,:city_id,:phone,:writer,:preuniversity,:notifications,:level_id,:image_data,:image_name,:tutorial,:ranking,:nem)
  end

  # Sanitize and format user data.
  def clear_params
    user_hash = user_params
    if user_hash[:first_name]
      user_hash[:first_name] =user_hash[:first_name].downcase
      user_hash[:first_name] = user_hash[:first_name].capitalize
    end
    if user_hash[:last_name]
      user_hash[:last_name] =user_hash[:last_name].downcase
      user_hash[:last_name] = user_hash[:last_name].capitalize
    end
    return user_hash
  end

end
