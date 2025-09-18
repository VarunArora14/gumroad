# frozen_string_literal: true

class Admin::Users::CommentsController < Admin::Users::BaseController
  before_action :fetch_user

  def index
    render json: {
      comments: json_payload(@user.comments.includes(:author))
    }
  end

  def create
    comment = @user.comments.with_type_note.new(
      author: current_user,
      **comment_params
    )

    if comment.save
      render json: { success: true, comment: json_payload(comment) }
    else
      render json: { success: false, error: comment.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :comment_type)
    end

    def json_payload(serializable)
      serializable.as_json(
        only: %i[id author_name comment_type updated_at],
        include: {
          author: {
            only: %i[id name email],
          }
        },
        methods: :content_formatted
      )
    end
end
