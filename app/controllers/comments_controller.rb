class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  
  def index
    @comments = @commentable.comments.includes(:user).order(created_at: :asc)
    respond_to do |format|
      format.json { render json: @comments.as_json(only: [:id, :body, :created_at], include: { user: { only: [:id, :email] }}) }
    end
  end

  def create
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      question_id = if @comment.commentable_type == "Question"
        @comment.commentable_id
      elsif @comment.commentable_type == "Answer"
        @comment.commentable.question_id
      end

      ActionCable.server.broadcast(
        "comments_for_question_#{question_id}",
        {
          comment: CommentBroadcastSerializer.new(@comment, view_context).as_json,
          commentable_type: @comment.commentable_type,
          commentable_id: @comment.commentable_id
        }
      )

      respond_to do |format|
        format.json {
          render json: @comment.as_json(
            only: [:id, :body, :created_at],
            include: { user: { only: [:id] } }
          ), 
          status: :created
        }
      end
    else
      respond_to do |format|
        format.json {
          render json: { errors: @comment.errors.full_messages }, 
          status: :unprocessable_entity 
        }
      end
    end
  end

  private

  def set_commentable
    @commentable =
      if params[:question_id]
        Question.find(params[:question_id])
      elsif params[:answer_id]
        Answer.find(params[:answer_id])
      end
    head :bad_request unless @commentable
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
