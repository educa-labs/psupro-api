class Api::V1::PredictionController < ApplicationController
  before_action :authenticate_with_token!, only: [:index, :show]
  respond_to :json

  include PredictionHelper

  def show

    psu_date = DateTime.new(2017,11,27)
    subject_id = params[:id]
    essays = current_user.essays.where(subject_id: subject_id).order("date_full ASC")
    objective_score = current_user.objectives.find_by(subject_id: subject_id).score
    if essays.length >= 3
      result = predict(essays,psu_date,subject_id,objective_score)
      render json:result, status:200
    else
      render json: {errors:"No se encontraron ensayos suficientes"}
    end
  end


end
