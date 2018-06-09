class Api::V1::RegionsController < ApplicationController

  def index
    render json:Region.all, status: 200
  end

  def show
    render json:Region.find_by(id: params[:id]), status:200
  end
end
