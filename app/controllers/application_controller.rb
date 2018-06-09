class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  # Render errors as json instead of HTML.

  rescue_from ActionController::RoutingError do |exception|
    render json: { error: exception.message }, :status => 404
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: exception.message }, :status => 404
  end

  rescue_from ActionController::UnknownController do |exception|
    render json: { error: exception.message }, :status => 404
  end

  rescue_from StandardError do |exception|
    render json: { error: exception.message }, :status => 500
  end

  include Authenticable

end
