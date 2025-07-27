class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy delete_file]
  before_action :set_answer, only: %i[show]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions_created.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question soccessfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params.except(:files))
      if params[:question][:files].present?
        @question.files.attach(params[:question][:files])
      end
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question has been successfully deleted'
    else
      redirect_to @question
    end
  end

  def delete_file
    if current_user.author_of?(@question)
      file = @question.files.attachments.find(params[:file_id])
      file.purge
      @question.reload
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def set_answer
    @answer = @question.answers.new
  end
end
