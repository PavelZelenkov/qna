class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @question = Question.find(params[:question_id])
    @answers = @question.answers
    render json: @answers, each_serializer: AnswerShortSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_resource_owner
    authorize! :create, @answer

    if @answer.save
      render json: @answer, serializer: AnswerSerializer, status: :created
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @answer = current_resource_owner.answers_created.find(params[:id])
    authorize! :update, @answer

    if @answer.update(answer_params)
      render json: @answer, serializer: AnswerSerializer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer = current_resource_owner.answers_created.find(params[:id])
    authorize! :destroy, @answer

    @answer.destroy!
    head :no_content
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
