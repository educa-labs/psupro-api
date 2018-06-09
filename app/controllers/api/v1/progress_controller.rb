class Api::V1::ProgressController < ApplicationController
  before_action :authenticate_with_token!, only: [:index, :show]
  respond_to :json

  def index
    if params[:subject_id]
      ess = get_essays(params[:subject_id])
      if ess != []
        serializor = ess.map {|x| EssaySerializer.new(x)} # Serialize array
        render json:{stats:stats(ess),essays:serializor.as_json}, status:200
      else
        render json:{stats:{},essays:[]}, status:200
      end
    else
      render json:{errors:"must provide subject_id"}, status:422
    end
  end

  # TODO: Fix This
  def show
    goal = current_user.carreers.find_by(id: params[:goal_id])
    if goal
      scores = {language:stats(get_essays(1)), math:stats(get_essays(2)),history:stats(get_essays(3)),science:stats(get_essays(4))}
      puts scores
      objts = current_user.objectives
      l_obj =objts.find_by(subject_id:1)
      m_obj = objts.find_by(subject_id:2)
      h_obj = objts.find_by(subject_id:3)
      s_obj =objts.find_by(subject_id:4)
      if goal.weighing.science && goal.weighing.history
        max_score_science = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:max] + goal.weighing.math * scores[:math][:max] +
            goal.weighing.science * scores[:science][:max]) /100
        avg_score_science = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:expectation] + goal.weighing.math * scores[:math][:expectation] +
            goal.weighing.science * scores[:science][:expectation]) /100
        avg_score_history = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:expectation] + goal.weighing.math * scores[:math][:expectation] +
            goal.weighing.history * scores[:history][:expectation]) /100
        max_score_history = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:max] + goal.weighing.math * scores[:math][:max] +
            goal.weighing.history * scores[:history][:max]) /100
        obj_score_history= ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * l_obj.score + goal.weighing.math * m_obj.score +
            goal.weighing.history * h_obj.score) /100)
        obj_score_science = ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * l_obj.score + goal.weighing.math * m_obj.score +
            goal.weighing.science * s_obj.score) /100)
        render json:{max_science: max_score_science, avg_science: avg_score_science, obj_science:obj_score_science,max_history: max_score_history, avg_history:avg_score_history, obj_history:obj_score_history,last_cut:goal.last_cut}, status:200
      elsif goal.weighing.science
        max_score_science = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:max] + goal.weighing.math * scores[:math][:max] +
            goal.weighing.science * scores[:science][:max]) /100
        avg_score_science = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:expectation] + goal.weighing.math * scores[:math][:expectation] +
            goal.weighing.science * scores[:science][:expectation]) /100
        obj_score_science = ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * l_obj.score + goal.weighing.math * m_obj.score +
            goal.weighing.science * s_obj.score) /100)
        render json:{max_science: max_score_science, avg_science: avg_score_science,obj_science:obj_score_science,last_cut:goal.last_cut}, status:200
      else
        avg_score_history = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:expectation] + goal.weighing.math * scores[:math][:expectation] +
            goal.weighing.history * scores[:history][:expectation]) /100
        max_score_history = (goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * scores[:language][:max] + goal.weighing.math * scores[:math][:max] +
            goal.weighing.history * scores[:history][:max]) /100
        obj_score_history= ((goal.weighing.NEM * current_user.nem + goal.weighing.ranking*current_user.ranking +
            goal.weighing.language * l_obj.score + goal.weighing.math * m_obj.score +
            goal.weighing.history * h_obj.score) /100)
        render json:{max_history: max_score_history, avg_history:avg_score_history,obj_history:obj_score_history,last_cut:goal.last_cut}, status:200
      end
    else
      render json:{errors:"must provide a goal id"}
    end

  end

  private

  def stats(essays)
    st = {}
    st[:expectation] = essays.sum {|x| x.score} / essays.length
    st[:max] = essays.max_by {|x| x.score}.score
    return st
  end

  def get_essays(subject_id)
    Essay.where(subject_id: subject_id, user_id: current_user.id).includes(:subject).order('date_full ASC')
  end

end
