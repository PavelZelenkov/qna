require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth::AuthHash.new({
      provider: 'github',
      uid: '123',
      info: { email: 'github@test.com' }
    })
  end
  
  describe 'Github' do
    let(:oauth_data) { { 'provider' => 'github', 'uid' => '123' } }
    
    it 'finds user from omniauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Twitter' do
    let(:oauth_data) do 
      OmniAuth::AuthHash.new({
        provider: 'twitter',
        uid: '456',
        info: { email: 'twitter@test.com' }
      })
    end

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.env['omniauth.auth'] = oauth_data
    end

    it 'finds user from omniauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :twitter
    end

    context 'user exists and confirmed' do
      let!(:user) { create(:user, email: 'twitter@test.com', confirmed: true) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :twitter
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user exists, not confirmed' do
      let!(:user) { create(:user, email: 'twitter@test.com', confirmed: false) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :twitter
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end

      it 'redirects to root path with alert' do
        expect(response).to redirect_to root_path
      end
    end

    context 'no user and no email' do
      let(:oauth_data) do 
        OmniAuth::AuthHash.new({
          provider: 'twitter',
          uid: '456',
          info: { email: 'twitter@test.com' }
        })
      end

      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        allow(User).to receive(:find_for_oauth).and_return(nil)
        get :twitter
      end

      it 'redirects to new_email_confirmation_path' do
        expect(response).to redirect_to new_email_confirmation_path
      end
    end
  end
end
