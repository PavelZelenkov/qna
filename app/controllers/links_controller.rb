class LinksController < ApplicationController

  before_action :authenticate_user!
  before_action :set_link, only: %i[destroy]
  before_action :authorize_user!, only: %i[destroy]

  def destroy
    @link.destroy
  end
  
  private

  def set_link
    @link = Link.find(params[:id])
    @linkable = @link.linkable
  end

  def authorize_user!
    unless current_user&.author_of?(@linkable)
      head :forbidden
    end
  end

end
