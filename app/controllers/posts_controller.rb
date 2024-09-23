class PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]
  before_action :is_authorized, only: %i[ update destroy ]

  # GET /posts
  def index
    @posts = Post.all

    render json: @posts
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params.merge(author: current_user))

    if @post.save
      @tags = Tag.insert_all(tag_params(@post))
      if !@tags.empty?
        render json: @post, status: :created, location: @post
      else
        render json: @tags.errors, status: :unprocessable_entity
      end
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if params[:tags]
      @tags = Tag.insert_all(tag_params(@post))
      if @tags.empty?
        render json: @tags.errors, status: :unprocessable_entity
      end
    end

    if params[:delete_tags] && @post.tags.size > params[:delete_tags].size
      Tag.where(post_id: @post.id, id: params[:delete_tags]).destroy_all
    end

    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!
  end

  private

  def is_authorized
    unless current_user.id == @post.author.id
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body)
  end

  def tag_params(post)
    tags = []
    params.require([:tags])[0].each do |tag_name|
      tags << { text: tag_name, post_id: post.id }
    end
    return tags
  end
end
