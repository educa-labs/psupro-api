module PredictionHelper

  # Returns predicted psu score from essays.
  def predict(essays,query_date,subject_id,objective_score)
    url = 'newton.tuniversidad.cl/get_prediction' # Newton URL.
    # Get first day date to use as reference.
    start_date = essays.first.date_full.to_date
    # Calculate psu day based on reference.
    query_day = (query_date.to_date - start_date).to_i
    # Map dates to integers based on reference.
    relative_days = essays.map {|e| (e.date_full.to_date - start_date).to_i}
    scores = essays.map {|e| e.score}
    # Create payload for request and execute.
    payload = {scores:scores, days:relative_days, query_day:query_day, query_score:objective_score}
    response = RestClient.post(url,payload.to_json, {content_type: :json, accept: :json})
    result = JSON.parse(response)
    if result['prediction'] > 850
      result['prediction'] = 850
    end
    return result
  end
end
