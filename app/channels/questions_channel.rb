class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions"
    stream_from "answers_for_question_#{params[:question_id]}"
    stream_from "comments_for_question_#{params[:question_id]}"
  end
end
