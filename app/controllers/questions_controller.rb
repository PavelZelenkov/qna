class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :the_set_answer, only: %i[show]
  before_action :find_author, only: %i[create destroy]

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
    @question = Question.new(question_params)
    @question.author_id = @author.id

    if @question.save
      redirect_to @question, notice: 'Your question soccessfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @question.author == @author
      @question.destroy
      redirect_to questions_path, notice: 'Your question has been successfully deleted'
    else
      redirect_to @question, notice: 'You cannot delete a question you did not author'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def the_set_answer
    @answer = @question.answers.new
  end

  def find_author
    @author = current_user
  end
end
