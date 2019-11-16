class IdeasController < ApplicationController

  INDEX_RECORDS_PAGE = 10

  before_action :check_current_user_is_logged_in

  def create
    @idea = Idea.new(permitted_params)
    if(@idea.save)
      render :show, status: :created
    else
      render json: { errors: @idea.errors }, status: :bad_request
    end
  end

  def show
    load_idea
    if(@idea)
      render :show, status: :ok
    else
      render json: { errors: ["There was not an Idea record with #{params[:id]} id."] }, status: :not_found
    end
  end

  def index
    page = params[:page].nil? ? 1 : params[:page].to_i
    render json: { errors: ["Page should be a valid integer"] }, status: 400 if page < 0
    @ideas = Idea.limit(INDEX_RECORDS_PAGE).offset((page - 1) * INDEX_RECORDS_PAGE)
    render :index, status: :ok
  end

  def update
    load_idea
    render json: { errors: ["There was not an Idea record with #{params[:id]} id."] }, status: :not_found if @idea.nil?

    if @idea.update(permitted_params)
      render :show, status: :ok
    else
      render json: { errors: @idea.errors }, status: :bad_request
    end
  end

  def destroy
    load_idea
    render json: { errors: ["There was not an Idea record with #{params[:id]} id."] }, status: :not_found if @idea.nil?

    if @idea.destroy
      head :no_content
    else
      render json: { errors: "There was an issue removing the requested idea with id #{@idea.id}" }, status: :not_modified
    end
  end

  private

  def load_idea
    @idea = Idea.find(params[:id])
  end

  def permitted_params
    params.permit(:content, :impact, :ease, :confidence)
  end

end
