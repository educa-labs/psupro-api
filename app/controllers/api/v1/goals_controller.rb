class Api::V1::GoalsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create,:destroy,:index, :show]
  respond_to :json

  def create
    if params[:carreer] && params[:carreer][:id]
      car = Carreer.find_by(id: params[:carreer][:id])
      if car
        begin
          current_user.carreers << car # We add the career to objectives and calculate scores.
          objts = current_user.objectives
          l_obj = objts.find_by(subject_id:1)
          m_obj = objts.find_by(subject_id:2)
          h_obj = objts.find_by(subject_id:3)
          s_obj = objts.find_by(subject_id:4)
          render json: calculate_scores(car,l_obj,m_obj,h_obj,s_obj), status:201, location:[:api,current_user]
        rescue
          render json:{errors:{carreer:{id:"carreer already added"}}}, status: 422
        end
      else
        render json:{errors:{carreer:{id:"must ve a valid carreer id"}}}, status: 422
      end
    else
      render json:{errors:{carreer:{id:"can't be missing"}}}, status: 422
    end

  end

  def destroy
    goal = current_user.carreers.find_by(id: params[:id]) # We find goal by career id.
    current_user.carreers.delete(goal)
    head 204
  end


  def index
    result = []
    if current_user.nem.nil? || current_user.ranking.nil?
      render json:{errors:{user:"user must have nem and ranking"}}, status:422
      return
    end
    # We get objectives and use them to calculate scores for all goals.
    objts = current_user.objectives
    l_obj =objts.find_by(subject_id:1)
    m_obj = objts.find_by(subject_id:2)
    h_obj = objts.find_by(subject_id:3)
    s_obj =objts.find_by(subject_id:4)
    current_user.carreers.includes(:weighing).each do |goal|
      result.append(calculate_scores(goal,l_obj,m_obj,h_obj,s_obj))
    end
    render json:result, status:200
  end



  def show
    # Returns true if career of id params[:id] is goal of current_user.
    render json: {goal:!current_user.carreers.find_by(id: params[:id]).nil?}, status:200
  end


  private

  # Calculates essay stats.
  def stats(essays)
    if essays.length > 0
      st = {}
      st[:expectation] = essays.sum {|x| x.score} / essays.length
      st[:max] = essays.max_by {|x| x.score}.score
      return st
    end
    return nil
  end

  def get_essays(subject_id)
    Essay.where(subject_id: subject_id, user_id: current_user.id).includes(:subject)
  end

  #TODO arreglar esta wea
  def calculate_scores(goal,l_obj,m_obj,h_obj,s_obj)
    serial = CarreerSerializer.new(goal)
    unless goal.weighing?
      return {scores:nil,carreer:serial.as_json}
    end
    scores = {language:stats(get_essays(1)), math:stats(get_essays(2)),history:stats(get_essays(3)),science:stats(get_essays(4))}
    l_essays = scores[:language].nil?
    m_essays = scores[:math].nil?
    s_essays = scores[:science].nil?
    h_essays = scores[:history].nil?
    if goal.weighing.science && goal.weighing.history
      if !(l_essays || m_essays)
        if !s_essays
          max_score_science = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
              goal.weighing.language * scores[:language][:max] + goal.weighing.math * scores[:math][:max] +
              goal.weighing.science * scores[:science][:max]) /100
          avg_score_science = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
              goal.weighing.language * scores[:language][:expectation] + goal.weighing.math * scores[:math][:expectation] +
              goal.weighing.science * scores[:science][:expectation]) /100
        else
          max_score_science = nil
          avg_score_science = nil
        end
        if !h_essays
          avg_score_history = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
              goal.weighing.language * scores[:language][:expectation] + goal.weighing.math * scores[:math][:expectation] +
              goal.weighing.history * scores[:history][:expectation]) /100
          max_score_history = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
              goal.weighing.language * scores[:language][:max] + goal.weighing.math * scores[:math][:max] +
              goal.weighing.history * scores[:history][:max]) /100
        else
          avg_score_history = nil
          max_score_history = nil
        end
      else
        max_score_science = nil
        avg_score_science = nil
        max_score_history = nil
        avg_score_history = nil
      end
      if !(h_obj.nil? || m_obj.nil? || l_obj.nil?)
        obj_score_history= ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * l_obj.score + goal.weighing.math * m_obj.score +
            goal.weighing.history * h_obj.score) /100).to_i
      else
        obj_score_history = nil
      end
      if !(s_obj.nil? || m_obj.nil? || l_obj.nil?)
        obj_score_science = ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * l_obj.score + goal.weighing.math * m_obj.score +
            goal.weighing.science * s_obj.score) /100).to_i
      else
        obj_score_science = nil
      end
      return {scores:{science:{max: max_score_science, avg: avg_score_science, obj:obj_score_science},history:{max: max_score_history, avg:avg_score_history, obj:obj_score_history},last_cut:goal.last_cut},carreer:serial.as_json}
    elsif goal.weighing.science
      if !(l_essays || m_essays || s_essays)
        max_score_science = ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:max] + goal.weighing.math * scores[:math][:max] +
            goal.weighing.science * scores[:science][:max]) /100).to_i
        avg_score_science = ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:expectation] + goal.weighing.math * scores[:math][:expectation] +
            goal.weighing.science * scores[:science][:expectation]) /100).to_i
      else
        max_score_science = nil
        avg_score_science = nil
      end
      if !(s_obj.nil? || m_obj.nil? || l_obj.nil?)
        obj_score_science = ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * l_obj.score + goal.weighing.math * m_obj.score +
            goal.weighing.science * s_obj.score) /100).to_i
      else
        obj_score_science = nil
      end
      return {scores:{science:{max: max_score_science, avg: avg_score_science,obj:obj_score_science},history:nil,last_cut:goal.last_cut},carreer:serial.as_json}
    else
      if !(l_essays || m_essays || h_essays)
        avg_score_history = ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:expectation] + goal.weighing.math * scores[:math][:expectation] +
            goal.weighing.history * scores[:history][:expectation]) /100).to_i
        max_score_history = ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:max] + goal.weighing.math * scores[:math][:max] +
            goal.weighing.history * scores[:history][:max]) /100).to_i
      else
        avg_score_history = nil
        max_score_history = nil
      end
      if !(h_obj.nil? || m_obj.nil? || l_obj.nil?)
        obj_score_history= ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * l_obj.score + goal.weighing.math * m_obj.score +
            goal.weighing.history * h_obj.score) /100).to_i
      else
        obj_score_history = nil
      end
      return {scores:{history:{max: max_score_history, avg:avg_score_history,obj:obj_score_history},science:nil,last_cut:goal.last_cut},carreer:serial.as_json}
    end
  end

end
