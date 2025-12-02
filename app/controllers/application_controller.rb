class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        target_url =
          request.referer.presence ||
          (params[:id].present? ? question_path(params[:id]) : root_url)
        redirect_to target_url, alert: exception.message
      end
      format.json { render json: { errors: [exception.message] }, status: :forbidden }
      format.js   { render json: { errors: [exception.message] }, status: :forbidden }
    end
  end

  skip_authorization_check if :devise_controller?
end
