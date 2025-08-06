class AnswersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :load_answer, only: %i[update destroy mark_as_best]
  
  def create
    @answer = current_user.answers_created.new(answer_params)
    @answer.question_id = @question.id
    @answer.save
  end

  def update
    if @answer.update(answer_params.except(:files))
      if params[:answer][:files].present?
          @answer.files.attach(params[:answer][:files])
      end
    end
    @question = @answer.question
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of?(@answer)
  end

  def mark_as_best
    @answer.select_as_best
    @question = @answer.question
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
