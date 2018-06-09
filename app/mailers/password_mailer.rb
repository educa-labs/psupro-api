class PasswordMailer < ApplicationMailer
  default from:"soporte@tuniversidad.cl"

  def update_password_email(user,password)
    @user = user
    @password = password
    mail(to:user.email,subject:"Cambio de contraseña")
  end
end
