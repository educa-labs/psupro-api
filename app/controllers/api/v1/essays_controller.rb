class Api::V1::EssaysController < ApplicationController
  before_action :authenticate_with_token!, only: [:index, :create,:destroy]
  respond_to :json

  def index
    render json:current_user.essays.includes(:subject).order("essays.date_full ASC"), status:200
  end

  def create
    attributes = essay_params # sanitizer
    ess = Essay.new(attributes)
    ess.user_id = current_user.id
    if ess.save
      render json:ess, status:200
    else
      render json: {errors:ess.errors}, status: 422
    end
  end

  def destroy
    ess = current_user.essays.find_by(id:params[:id])
    if ess
      ess.destroy
      head 204
    else
      head 401
    end
  end
  
  private

  def essay_params
    params.require(:essay).permit(:subject_id,:score,:title,:date_full)
  end

end
