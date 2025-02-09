class AnswersController < ApplicationController
  
  before_action :find_question, only: %i[create]
  
  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question
    else
      redirect_to @question, notice: 'error creating answer to question'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
