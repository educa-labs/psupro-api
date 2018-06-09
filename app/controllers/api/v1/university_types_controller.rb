class Api::V1::UniversityTypesController < ApplicationController

  def index
    render json:UniversityType.all, status:200
  end
end
