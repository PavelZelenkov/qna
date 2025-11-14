module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '123545',
      info: {
        email: 'twitter@test.com',
        name: 'TestUser'
      },
      credentials: {
        token: 'mock_token',
        secret: 'mock_secret'
      }
    })
  end

  def mock_auth_error
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
  end
end
