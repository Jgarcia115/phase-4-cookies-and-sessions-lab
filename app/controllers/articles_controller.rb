class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    session[:page_views] ||= 0
    views = session[:page_views] += 1
    if (views <= 3)
      render json: article
      return
    else (views < 3)
      render json: {error: views.errors.full_messages}, status: :unauthorized
      return
    end
  

    render json: article
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
