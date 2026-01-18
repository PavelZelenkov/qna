class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def create
    subscription = @question.subscriptions.find_or_initialize_by(user: current_user)
    if subscription.persisted?
      redirect_to @question, notice: 'You are already subscribed to this question'
    elsif subscription.save
      redirect_to @question, notice: 'You have been subscribed to this question'
    else
      redirect_to @question, alert: 'Failed to subscribe to this question'
    end
  end

  def destroy
    subscription = @question.subscriptions.find_by(user: current_user)
    if subscription
      subscription.destroy
      redirect_to @question, notice: 'Subscription canceled'
    else
      redirect_to @question, notice: 'You are not subscribed to this question'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
