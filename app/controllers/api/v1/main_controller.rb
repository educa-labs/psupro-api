class Api::V1::MainController < ApplicationController

  # Random controller for some random functionalities

  def home
    render json:{messagge:"welcome to tuniversidad api"}
  end

  def schedules
    render json:{schedules:["Diurno","Vespertino"]}
  end

  # Gets 20 most popular universities
  def popular_universities
    render json:University.order('visits DESC').includes(:university_type).limit(params[:limit].to_i)
  end

  # Gets 20 most popular universities
  def popular_carreers
    render json:Carreer.order('visits DESC').includes(:weighing,:area).limit(params[:limit].to_i)
  end

  def validate_rut
    if params[:rut]
      rut = params[:rut]
      aux = User.new
      aux.rut = rut
      RUTValidator.new.validate(aux)
      unless aux.errors.empty?
        render json: {valid: false, error: "RUT inválido"}
        return
      end
      if User.find_by(rut:rut)
        render json: {valid: false, error: "RUT ocupado"}
        return
      end
      render json:{valid:true}
    elsif params[:rut] == "" || params[:rut].nil?
      render json: {valid: false, error: "RUT vacío"}
    end
  end
end
