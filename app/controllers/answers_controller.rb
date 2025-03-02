class AnswersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :load_answer, only: %i[destroy]
  
  def create
    @answer = current_user.answers_created.new(answer_params)
    @answer.question_id = @question.id
    
    if @answer.save
      redirect_to @question
    # else
    #   redirect_to @question, notice: 'error creating answer to question'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Your answer has been successfully deleted'
    else
      redirect_to @answer.question
    end
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
