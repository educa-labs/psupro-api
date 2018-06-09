class Api::V1::RecommendationController < ApplicationController
  before_action :authenticate_with_token!, only: [:create,:index,:update,:liked]
  respond_to :json
  include PredictionHelper
  include RecommendationHelper

  RECS_NUMBER = 3 # Number of recs to return.

  def create
    scores = []
    # ?essays=true we use essays to predict scores.
    if params['essays']
      psu_date = DateTime.new(2017,11,27) # PSU DAY
      user_essays = current_user.essays.order("date_full ASC")
      objectives = current_user.objectives
      [2,1,4,3].each do |s|
        completed = false
        subject_objective = objectives.select {|x| x.subject_id == s}.first # We get objective
        objective_score = subject_objective.nil? ? nil : subject_objective.score #  We get objective score.
        essays = user_essays.select { |x| x.subject_id == s}
        if essays.length >= 4 # If there is enough essays we use a prediction.
          result = predict(essays,psu_date,s,objective_score)
          if result['r_score'] > 0.2 # Valid prediction.
            scores.append result['prediction']
            completed = true
          end
        elsif essays.length == 0 # If no essays we assume is not relevant to user.
          scores.append 0
          completed = true
        end
        unless completed
          if objective_score.nil? # If score doesnt have objective we assume is not relevant to user.
            scores.append 0
          else
            scores.append objective_score
          end
        end
      end
      # We add NEM to score array.
      scores += [current_user.nem]

    # ?essays=false we use objectives as scores.
    else
      scores = []
      objs = current_user.objectives
      [2,1,4,3].each do |i|
        obj = objs.select {|x| x.subject_id == i}
        if obj.first
          scores.append(obj.first.score)
        else
          scores.append(0)
        end
      end
      # We add NEM to score array.
      scores += [current_user.nem]
    end

    # Calculating area.

    #?area=compute
    if params['area'] == 'compute'
      areas = current_user.carreers.map {|x| x.area_id}
      # We get the ids of the two most frequent areas in user goals.
      areas = areas.map {|x| [x, areas.count(x)]}.uniq.sort_by {|x| x[1]}.reverse[0..1].map {|x| x[0]}
    else
      areas = [params['area'].to_i]
    end

    # Request for recommendations
    url = 'newton.tuniversidad.cl/get_recommendations' # Newton URL
    areas.each do |area|
      payload = {area_id:area,scores:[scores]}
      response = RestClient.post(url,payload.to_json, {content_type: :json, accept: :json})
      result_req = JSON.parse(response)
      # We create a recommendation object for each result.
      result_req['result']["0"].each do |id|
        Recommendation.create do |rec|
          rec.user_id = current_user.id
          rec.carreer_id = id.to_i
          rec.liked = false
          rec.seen = false
          rec.area_id = area.to_i
          # We store params to use them on GET requests.
          rec.essay = params['essays']
          rec.computed_area = params['area'] == 'compute'
        end
      end
    end
    # Select a random subset of the created recs.
    result = random_select(current_user,RECS_NUMBER,params['essays'],params['area'])
    if result
      updater(result) # We set send recommendations to seen.
      render json:result, status:200
    else
      # IF random sampling fails we try with similar to he ones that have already been computed.
      sampled_area = areas.sample(1).first
      recs = Recommendation.where(user_id:current_user.id,liked:true,area_id: sampled_area.to_i)
      if recs.empty?
        recs = Recommendation.where(user_id:current_user.id,liked:false,area_id:sampled_area.to_i)
      end
      k = 5
      result = []
        while result.length < RECS_NUMBER
        recs.each do |rec|
          similars = request_similar([rec.carreer_id],k)
          similars[1...similars.length].each do |similar|
            new_rec = Recommendation.new do |new_rec|
              new_rec.user_id = current_user.id
              new_rec.carreer_id = similar
              new_rec.liked = false
              new_rec.seen = false
              new_rec.area_id = sampled_area.to_i
              new_rec.essay = params['essays']
              new_rec.computed_area = params['area'] == 'compute'
            end
            if new_rec.save
              result.append(new_rec)
            end
          end
        end
        k += 1
        end
      updater(result[0...RECS_NUMBER])
      render json:result[0...RECS_NUMBER], status:200
    end
  end

  # Random sample of already computed recommendations.
  def index
    ess = ActiveModel::Type::Boolean.new.cast(params['essays'])
    result = random_select(current_user,RECS_NUMBER,ess,params['area'])
    if not result.nil?
      updater(result)
      render json:result, status:200
    else
      render json:{errors:"not enough recs left. request POST"}, status:409
    end
  end

  # Sets Recommendation to liked.
  def update
    attributes = recommendation_params
    if not  attributes[:liked].nil?
      rec = Recommendation.find_by(id:params[:id])
      if rec && current_user.id == rec.user_id
        rec.update(recommendation_params)
        render json:rec, status:200
      else
        render json:{errors:"Invalid recommendation_id"},status:422
      end
    else
      render json:{errors:"must provide liked param"}, status:400
    end
  end

  # Returns liked recommendations.
  def liked
    recs = Recommendation.where(user_id:current_user.id,liked:true).includes(carreer:[:campu,:weighing,:area])
    render json:recs, status:200
  end

  private

  def recommendation_params
    params.require(:recommendation).permit(:liked)
  end

end
