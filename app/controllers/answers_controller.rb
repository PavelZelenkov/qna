class AnswersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :load_answer, only: %i[update destroy]
  
  def create
    @answer = current_user.answers_created.new(answer_params)
    @answer.question_id = @question.id
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of?(@answer)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
