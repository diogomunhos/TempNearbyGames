OmniAuth.config.logger = Rails.logger




Rails.application.config.middleware.use OmniAuth::Builder do 
  provider :facebook, '1735599803381451', 'a7205a16fb4510bf8ed005be03376222'
  provider :twitter, '70Kn3HsleZDySQH3EB80XONny', 'er6n2B4LbYjXBbEd4gyD9Cjefddp7TswDs15roTiOamTQtbgwt'
  provider :google_oauth2, '921198102107-1d0eusuaurt6eeem4qpeo5pchii7198m.apps.googleusercontent.com', 'le2IuIHs-86V39DX8uZ6Isar', {client_options: {ssl: {ca_file: Rails.root.join('lib/cacert.pem').to_s}}}
end