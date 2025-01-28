class AnswersController < ApplicationController
  
  before_action :find_question, only: %i[create]
  
  def new
  end

  def create
    @answer = @question.answers.create(answer_params)
    redirect_to @question
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
