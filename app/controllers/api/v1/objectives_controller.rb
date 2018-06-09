class Api::V1::ObjectivesController < ApplicationController
  before_action :authenticate_with_token!, only: [:index, :create]
  respond_to :json

  def index
    objs = current_user.objectives
    res = objs.map {|x| [x.subject_id,x.score]}.to_h # Maps objectives to hash {id:objective}.
    render json:res, status:200
  end

  def create
    errors = []
    result = []
    params['_json'].each do |par| # Iterate over json array.
      pars = ActionController::Parameters.new(par)
      ob = Objective.new(objective_params(pars)) # Create sanitized objective.
      if ob
        current_ob = current_user.objectives.find_by(subject_id:ob.subject_id)
        # If objective already existed we update it.
        if current_ob
          current_ob.score =  ob.score
          if current_ob.save
            result.append current_ob
          else
            errors.append current_ob.errors
          end
        # Else we create a new one.
        else
          ob.user_id = current_user.id
          if ob.save
            result.append ob
          else
            errors.append ob.errors
          end
        end
      else
        errors.append ob.errors
      end
    end
    if errors == []
      render json:result, status:200
    else
      render json:errors
    end
  end


  private

  def objective_params(pars)
    pars.require(:objective).permit(:subject_id,:score)
  end

end
