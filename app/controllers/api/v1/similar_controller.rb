class Api::V1::SimilarController < ApplicationController

  include RecommendationHelper

  # params ?carreer_id, ?k=(int)
  def index
    carreer_id = [params[:carreer_id].to_i]
    k = params[:k].to_i + 1
    request_result = request_similar(carreer_id,k)
    deleted = request_result.delete(carreer_id[0])
    if deleted.nil?
      request_result.pop()
    end
    render json:Carreer.where(id:request_result).includes(:campu,:weighing,:area,:university,university:[:university_type]), status:200
  end

end
