class AwardsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :authorize_user!

  def index
    @awards = current_user.awards.includes(:question)
  end

  private

  def authorize_user!
    if @user == current_user
      redirect_to root_path, alert: "No access"
    end
  end
end
