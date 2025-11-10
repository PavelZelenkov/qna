class CommentBroadcastSerializer
  def initialize(comment, view_context)
    @comment = comment
    @view = view_context
  end

  def as_json
    {
      id: @comment.id,
      body: @comment.body,
      created_at: @comment.created_at,
      user_id: @comment.user_id,
      user_email: @comment.user.email,
      commentable_type: @comment.commentable_type,
      commentable_id: @comment.commentable_id,
      html: @view.render(
        partial: "comments/comment",
        locals: { comment: @comment },
        formats: [:html]
      )
    }
  end

  private

  attr_reader :comment, :view
end
