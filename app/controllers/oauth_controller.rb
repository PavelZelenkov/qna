class OauthController < ApplicationController
  def callback
    if params[:error].present?
      head :unauthorized
    else
      render plain: "Authorization code: #{params[:code]}"
    end
  end
end
