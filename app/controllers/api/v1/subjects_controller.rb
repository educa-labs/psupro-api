class Api::V1::SubjectsController < ApplicationController

  def index
    render json:Subject.all, status: 200
  end

end
