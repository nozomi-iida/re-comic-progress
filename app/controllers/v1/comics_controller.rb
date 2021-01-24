class V1::ComicsController < ApplicationController
  before_action :authorized
  def index
    comics = Comic.all
    render json: comics, adapter: :json
  end

  def show 
    comic = Comic.find(params[:id])
    render json: comic
  end

  def create
    comic = @current_user.comics.build(comic_params)
    if comic.save
      render json: comic, adapter: :json, status: :created
    else
      render json: { errors: "can't create comic" }, status: :forbidden
    end
  end

  def update
    comic = Comic.find(params[:id])
    if current_user?(comic.user) && comic.update(comic_params)
      render json: comic, adapter: :json
    else
      render json: { errors: "can't update comic" }, status: :forbidden
    end
  end

  def destroy
    comic = Comic.find(params[:id])
    if current_user?(comic.user) && comic.destroy
      render status: 204
    else 
      render json: { errors: "can't delete comic" }, status: :forbidden
    end
  end

  private 
  
  def comic_params 
    params.require(:comic).permit(:title, :volume)
  end
end
