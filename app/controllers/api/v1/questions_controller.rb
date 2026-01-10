class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionShortSerializer
  end

  def show
    @question = Question.find(params[:id])
    render json: @question, serializer: QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions_created.build(question_params)
    Rails.logger.info @question.errors.full_messages unless @question.save

    if @question.save
      render json: @question, serializer: QuestionSerializer, status: :created
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @question = current_resource_owner.questions_created.find(params[:id])

    if @question.update(question_params)
      render json: @question, serializer: QuestionSerializer
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @question = current_resource_owner.questions_created.find(params[:id])
    @question.destroy!
    head :no_content
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
