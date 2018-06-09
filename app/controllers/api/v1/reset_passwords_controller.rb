class Api::V1::ResetPasswordsController < ApplicationController

  def index
    user = User.find_by(email: params[:email])
    if user
      # Generate and set new password
      password = Devise.friendly_token.first(8)
      user.password = password
      user.save
      # Send email.
      PasswordMailer.update_password_email(user,password).deliver_now
      render json:{email_sent:true}, status:200
    else
      render json: {email_sent:false,errors:"Invalid Email"}, status: 401
    end
  end

end
