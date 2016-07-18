OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do 
  provider :facebook, '1735599803381451', 'a7205a16fb4510bf8ed005be03376222'
end