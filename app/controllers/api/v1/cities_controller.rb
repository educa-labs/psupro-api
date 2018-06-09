class Api::V1::CitiesController < ApplicationController
#  before_action :authenticate_with_token!, only: [:show,:index]

  def show
    a = City.find_by(id: params[:id])
    if a
      render json:a, status:200
    else
      render json: {errors: "invalid id"}, status:404
    end
  end

  def index
    # Route regions/region_id/cities
    if params[:region_id]
      render json:City.where(region_id: params[:region_id]), status:200
    else
      render json:City.all, status:200
    end
  end

end
