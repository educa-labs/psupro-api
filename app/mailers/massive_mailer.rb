class MassiveMailer < ApplicationMailer
  default from:"soporte@tuniversidad.cl"

  # Sample massive email.
  def massive1(user)
      @user = user
      mail(to:user.email,subject:"Bienvenido a Tuniversidad!")
  end

end
