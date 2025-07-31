class AttachmentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_attachment, only: %i[destroy]
  before_action :authorize_user!

  def destroy
    @attachment.purge
  end

  private

  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @record = @attachment.record
  end

  def authorize_user!
    unless current_user&.author_of?(@record)
      head :forbidden
    end
  end
end
