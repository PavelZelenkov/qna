class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth = request.env['omniauth.auth']
    email = auth.info[:email] rescue nil
  
    @user = User.find_for_oauth(auth)
  
    if email.blank?
      session['devise.oauth_data'] = auth.except('extra')
      redirect_to new_email_confirmation_path, alert: "Enter your Email to complete registration"
      return
    end
  
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
  

  def twitter
    auth = request.env['omniauth.auth']
    email = auth.info[:email]
  
    @user = User.find_for_oauth(auth)
  
    if @user.present? && @user.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
      return
    end
  
    if @user.present?
      redirect_to root_path, alert: 'First, confirm your email, check your mail.'
      return
    end
  
    if email.blank?
      session['devise.oauth_data'] = auth.except('extra')
      redirect_to new_email_confirmation_path, alert: "Confirm your email to access!"
      return
    end
  
    session['devise.oauth_data'] = auth.except('extra')
    redirect_to new_email_confirmation_path, alert: "Confirm your email to access!"
  end
end
