class Api::V1::AreasController < ApplicationController

  def index
    render json: Area.all, status: 200
  end

  # Returns area image.
  def show
    area = Area.find_by(id:params[:id])
    if area
      render json: {image:area.encoded_picture}, status:200
    else
      render json: {errors:"invalid id"}, status:404
    end
  end
end
