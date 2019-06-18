require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mappura
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    #タイムゾーン設定を東京に
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # サービスをオートロードする
    config.eager_load_paths += %W( #{config.root}/app/service/sql_service )
    config.eager_load_paths += %W( #{config.root}/extras )


    config.generators do |g|
        g.test_framework :rspec,
          view_specs: false
    end

  end
end
