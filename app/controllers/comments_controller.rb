class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show update destroy ]
  before_action :is_authorized, only: %i[ update destroy ]

  # GET /comments
  def index
    @comments = Comment.where(post_id: list_comment_params)

    render json: @comments.as_json(include: [:author])
  end

  # GET /comments/1
  def show
    render json: @comment
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params.merge(author: current_user))

    if @comment.save
      render json: @comment.as_json(include: [:author]), status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(edit_comment_params)
      render json: @comment.as_json(include: [:author])
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy!
  end

  private

  def is_authorized
    unless current_user.id == @comment.author.id
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:text, :post_id)
  end

  def list_comment_params
    params.require(:post_id)
  end

  def edit_comment_params
    params.require(:comment).permit(:text)
  end
end
