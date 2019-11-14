class IdeasController < ApplicationController

  INDEX_RECORDS_PAGE = 10

  def create
    @idea = Idea.new(permitted_params)
    if(@idea.save)
      render :show, status: 201
    else
      render json: { errors: @idea.errors }, status: 400
    end
  end

  def show
    loadIdea
    if(@idea)
      render :show, status: 200
    else
      render json: { errors: ["There was not an Idea record with #{params[:id]} id."] }, status: 400
    end
  end

  def index
    page = params[:page] || 1
    render json: { errors: ["Page should be a valid integer"] }, status: 400 if page < 0
    @ideas = Idea.limit(INDEX_RECORDS_PAGE).offset((page - 1) * INDEX_RECORDS_PAGE)
    render :index, status: 200
  end

  def update
    loadIdea
    render json: { errors: ["There was not an Idea record with #{params[:id]} id."] }, status: 400 if @idea.nil?

    if @idea.update(permitted_params)
      render :update, status: 200
    else
      render json: { errors: @idea.errors }, status: 400
    end
  end

  def destroy
    loadIdea
    render json: { errors: ["There was not an Idea record with #{params[:id]} id."] }, status: 400 if @idea.nil?

    if @idea.update(permitted_params)
      render :update, status: 200
    else
      render json: { errors: @idea.errors }, status: 400
    end
  end

  private

  def loadIdea
    @idea = Idea.find(params[:id])
  end

  def permitted_params
    params.require(:idea).permit(:content, :impact, :ease, :confidence)
  end

end