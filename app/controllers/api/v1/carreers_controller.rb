class Api::V1::CarreersController < ApplicationController
  before_action :authenticate_with_token_admin!, only: [:create,:update, :delete]

  def show
    ca = Carreer.where(id:params[:id]).includes(:campu,:weighing,:area,:university).limit(1).first
    if ca
      if current_user && !current_user.admin
        ca.visits +=1 # Update visits count for most popular route.
        ca.save
      end
      ca.render_picture = true
      render json:ca, status:200
    else
      render json: {errors: "invalid id"}, status:404
    end
  end

  def create
    attributes = carreer_params
    w_attributes = weighing_params 
    carreer = Carreer.new(attributes)
    carreer.weighing = Weighing.new(w_attributes)
    if carreer.save && carreer.weighing.save
      render json: carreer, status:201
    else
      render json: {errors: {carreer: carreer.errors, weighing:carreer.weighing.errors}}, status:422
    end
  end

  def update
    carreer = Carreer.find(params[:id])
    attributes = carreer_params
    w_attributes = weighing_params 
    carreer.update(attributes)
    carreer.weighing.update(w_attributes)
    if carreer.save && carreer.weighing.save
      render json: carreer, status:201
    else
      render json: {errors: {carreer: carreer.errors, weighing:carreer.weighing.errors}}, status:422
    end
  end

  def destroy
    carreer = Carreer.find(params[:id])
    if carreer
      carreer.destroy
      render  json: { status: 'success'}, status:200
    else
      render  json: { status: 'failure'}, status:422
    end
  end

  def index
    # Route universities/university_id/carreers
    if params[:university_id]
      render json:Carreer.where(university_id: params[:university_id]).order("title ASC").includes(:campu,:weighing,:area,:university)
    else
      render json:Carreer.order("title ASC").includes(:campu,:weighing,:area,:university)
    end
  end

  private

  def carreer_params
    params.require(:carreer).permit(:title,:university_id,:campu_id,:semesters,:price,:schedule,:openings,:employability,:income,:admission,:last_cut,:description,:area_id,:visits,:certification,:demre_id,:degree_type,:weighing)
  end

  def weighing_params
    params.require(:weighing).permit(:NEM,:ranking,:language,:math,:science,:history)
  end
end