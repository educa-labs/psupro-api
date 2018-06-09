class Api::V1::CampusController < ApplicationController
  before_action :authenticate_with_token_admin!, only: [:create,:update,:destroy]

  def show
    a = Campu.find_by(id: params[:id])
    if a
      render json:a, status:200
    else
      render json:{errors:"invalid id"}, status:404
    end
  end

  def create
    attributes = campu_params
    campu = Campu.new(attributes)
    if campu.save
      render json:campu, status:201
    else
      render json: {errors: campu.errors}, status: 422
    end
  end

  def update
    attributes = campu_params
    campu = Campu.find(params[:id])
    campu.update(attributes)
    if campu.save
      render json:campu, status:201
    else
      render json: {errors: campu.errors}, status:422
    end
  end

  def index
    # Route cities/city_id/campus .
    if params[:city_id]
      render json:Campu.where(city_id: params[:city_id]), status:200
    # Route universities/university_id/campus .
    elsif params[:university_id]
      render json:Campu.where(university_id: params[:university_id]), status:200
    else
      render json:Campu.all, status:200
    end
  end

  def destroy
    campu = Campu.find(params[:id])
    if campu
      campu.destroy
      render json: {status: "success"}, status:200
    else
      render json: {status: "failure"}, status:422
    end
  end

  private

  def campu_params
    params.require(:campu).permit(:title,:university_id, :lat, :long, :address,:city_id)
  end

end
