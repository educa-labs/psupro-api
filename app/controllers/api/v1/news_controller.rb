class Api::V1::NewsController < ApplicationController
  before_action :authenticate_with_token_admin!, only: [:create,:update, :destroy]

  def index
    render json:New.all.order("id DESC") , status:200
  end


  def show
    nw = New.find_by(id:params[:id])
    if nw
      if params[:image].nil?
          render json:nw, status:200
      else
        render json:{new: nw, picture:nw.encoded_picture},status: 200 # Return base64 image string.
      end
    else
      render json:{errors:{new:"new_id doesn't exist"}}, status:200
    end
  end

  def create
    attributes = new_params
    nw = New.new(attributes)
    if nw.save
      nw.update_picture(picture_params)
      render json: nw, status:201
    else
      render json: {errors: nw.errors}, status:422
    end
  end

  def update
    attributes = new_params
    nw = New.find_by(id:params[:id])
    if nw.update(attributes)
      nw.update_picture(picture_params)
      render json: nw, status:201
    else
      render json: {errors: nw.errors}, status:422
    end
  end 

  def destroy
    nw = New.find_by(id:params[:id])
    if nw
      nw.destroy
      render json: {status: "success"}, status:200
    else
      render json: {status: "failure"}, status:422
    end
  end

  private

  def new_params
    params.require(:new).permit(:body,:title,:lowering,:author)
  end

  def picture_params
    params.permit(:picture, :extension)
  end

end
