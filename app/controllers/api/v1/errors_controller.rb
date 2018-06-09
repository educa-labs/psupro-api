class Api::V1::ErrorsController < ApplicationController

  def error_404
    render json:{errors:["invalid route"]}, status:404
  end

end
