require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GameSiteApp
  class Application < Rails::Application
    @url_base = "http://localhost:3000"
    @signin_url = "#{@url_base}/signin"

    @logout_url = "#{@url_base}/logout"

    @secured_new_article_url = "#{@url_base}/private/articles/new"

    @secured_my_article_url = "#{@url_base}/private/articles/my-articles"

    @secured_show_profile_url = "#{@url_base}/private/profile/show"

    @secured_home_url = "#{@url_base}/private/index"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    require Rails.root.join("lib/custom_public_exceptions")
    config.exceptions_app = CustomPublicExceptions.new(Rails.public_path)
    config.active_record.raise_in_transactional_callbacks = true
  end
end
