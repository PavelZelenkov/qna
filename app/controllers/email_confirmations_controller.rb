class EmailConfirmationsController < ApplicationController
  def new
  end

  def create
    auth = session['devise.oauth_data']
    email = params[:email]
  
    user = User.find_by(email: email)
    if user
      if user.authorizations.find_by(provider: auth['provider'], uid: auth['uid'].to_s).nil?
        user.create_authorization(auth)
      end
  
      confirmation = user.email_confirmations.where(confirmed: false).first_or_create!(
        token: SecureRandom.urlsafe_base64
      )
      UserMailer.confirmation(user, confirmation).deliver_now
      redirect_to root_path, notice: 'Please check your email for confirmation'
      return
    end
  
    user = User.new(email: email, password: Devise.friendly_token[0, 20])
    if user.save
      user.create_authorization(auth)
      confirmation = user.email_confirmations.create!(
        token: SecureRandom.urlsafe_base64,
        confirmed: false
      )
      UserMailer.confirmation(user, confirmation).deliver_now
      redirect_to root_path, notice: 'Please check your email for confirmation'
    else
      flash.now[:alert] = user.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end
  
  def confirm
    confirmation = EmailConfirmation.find_by(token: params[:token])
    if confirmation && !confirmation.confirmed?
      confirmation.update(confirmed: true)
      user = confirmation.user
      user.update(confirmed: true)
      if session['devise.oauth_data']
        unless user.authorizations.exists?(provider: session['devise.oauth_data']['provider'], uid: session['devise.oauth_data']['uid'].to_s)
          user.create_authorization(session['devise.oauth_data'])
        end
        session.delete('devise.oauth_data')
      end
      sign_in user
      redirect_to root_path, notice: 'Email successfully confirmed, login complete!'
    else
      redirect_to root_path, alert: 'Incorrect or outdated link'
    end
  end   
end
