OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
  provider: 'github',
  uid: '123545',
  credentials: {
    token: "token",
    secret: "secret"
  }
})

OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
  provider: 'twitter',
  uid: '123545',
  credentials: {
      token: "token",
      secret: "secret"
  }
})