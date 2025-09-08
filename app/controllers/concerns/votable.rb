module Votable
  extend ActiveSupport::Concern

  def vote
    votable = controller_name.classify.constantize.find(params[:id])
    vote = votable.votes.find_by(user: current_user)

    if vote && vote.value == params[:value].to_i
      vote.destroy
      current_rating = votable.votes.sum(:value)
      render json: { id: votable.id, rating: current_rating }
    else
      vote = votable.votes.find_or_initialize_by(user: current_user)
      vote.value = params[:value].to_i
      if vote.save
        render json: { id: votable.id, rating: votable.votes.sum(:value) }
      else
        render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
