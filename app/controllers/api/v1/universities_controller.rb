class Api::V1::UniversitiesController < ApplicationController
  before_action :authenticate_with_token_admin!, only: [:create,:update, :destroy]
  respond_to :json

  def show
    u = University.find(params[:id])
    if u
      if params[:image].nil?
        if current_user && !current_user.admin
          u.visits += 1 # Update count for most popular.
          u.save
        end
        render json:u, status: 200
      else
        render json:{university: u, cover:u.encoded_cover_picture,profile:u.encoded_profile_picture} # Return images.
      end
    else
      render json:{errors:"invalid id"}, status: 404
    end
  end


  def create
    attributes = university_params
    uni = University.new(attributes)
    if uni.save
      uni.update_pictures(picture_params)
      render json: uni, status:201
    else
      render json: {errors: uni.errors}, status:422
    end
  end


  def update
    attributes = university_params
    uni = University.find(params[:id])
    uni.update(attributes)
    if uni.save
      uni.update_pictures(picture_params)
      render json: uni, status:201
    else
      render json: {errors: uni.errors}, status:422
    end
  end

  def index
    # /cities/city_id/universities .
    if params[:city_id]
      render json:City.find_by(id: params[:city_id]).universities.includes(:university_type).order("title asc"), status:200
    else
      render json: University.all.includes(:university_type).order("title asc"), status:200
    end
  end

  def destroy
    u = University.find(params[:id])
    if u
      u.destroy
      render json: {status: "success"}, status:200
    else
      render json: {status: "failure"}, status:422
    end

  end
  
  private

  def university_params
    params.require(:university).permit(:foundation,:website,:freeness,:motto,:nick,:initials,:students,:teachers,:degrees,:postgraduates,:doctorates,:description,:visits,:title,:level,:university_type_id)
  end

  def picture_params
    params.permit(:cover,:profile,:cover_extension,:profile_extension)
  end

end