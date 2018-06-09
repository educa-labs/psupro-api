class Api::V1::SearchController < ApplicationController
  # before_action :authenticate_with_token!, only: [:create]
  respond_to :json

  PAGE_SIZE = 10

  # /search?text=string&minimize=boolean&pictures=boolean&degree_type=integer
  def index
    if params[:text] # If we received a correct query.
      result = {}
      where_university = {} # Filters for universities.
      where_carreer = {} # Filters for carreers.
      # Input sanitize.
      degree_type = [1,2].include?(params[:degree_type].to_i) ? params[:degree_type].to_i : nil
      city_id = params[:city].to_i
      region_id = params[:region].to_i

      if degree_type # If degree type was given correctly
        where_carreer[:degree_type] = degree_type  # We search on carreers with given degree type.
        where_university[:level] = [0,degree_type] # We search on universities that have both types or just the asked type.
      end

      if city_id != 0 # If valid city_id
        where_university[:cities] = city_id
        where_carreer[:city_id] = city_id
      end

      if region_id != 0 # If valid region_id
        where_university[:regions] = region_id
        where_carreer[:region_id] = region_id
      end

      # University search
      university_result = University.search(
        params[:text],
        fields: [:title, :description, :initials],
        where: where_university,
        page: params[:page] || 1, # Pagination
        per_page: params[:page_size] || PAGE_SIZE,
        misspellings: {edit_distance: 3, below:5}
        )

      minimize = ActiveModel::Type::Boolean.new.cast(params[:minimize]) # Casting param to boolean and result minimization if necessary.
      result[:universities] = minimize ? university_result.map { |x| {id: x.id, title: x.title} } : university_result.map {|x| x.as_json(methods: :u_type)}

      # Carreer search
      carreer_result = Carreer.search(
        params[:text],
        fields: [:title,:description],
        where: where_carreer,
        includes: [:university,:campu],   # To prevent n+1 query.
        page: params[:page] || 1, # Pagination
        per_page: params[:page_size] || PAGE_SIZE,
        misspellings: {edit_distance: 3, below:5}
        )
      # Result minimization if necessary.
      result[:carreers] = minimize ? carreer_result.map { |x| {id: x.id, title: x.title, university_title: x.university.title, university_id:x.university.id} } : carreer_result.map {|x| x.as_json(methods: [:campu_name,:university_title,:university_initials])}

      # We add pictures if requested.
      if ActiveModel::Type::Boolean.new.cast(params[:pictures])
        profiles = University.profile_hash(result[:universities].map { |x| x["id"]})
        covers = University.cover_hash(result[:universities].map { |x| x["id"]})

        carreer_covers = University.profile_hash(carreer_result.map { |x| x["university_id"]})

        result[:universities].each do |university|
          university[:profile] = profiles[university["id"]]
          university[:cover] = covers[university["id"]]
        end
        result[:carreers].each do |carreer|
          carreer[:university_picture] = carreer_covers[carreer["university_id"]]
        end
      end

      render json: result , status:200
    else

      render json:{errors:"no search params"}, status:422
    end
  end

end
