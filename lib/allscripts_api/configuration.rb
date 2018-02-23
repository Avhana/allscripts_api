# frozen_string_literal: true

module AllscriptsApi
  # Configuration class to allow configuration on application
  # initialization. Configuration should look like the following.
  #
  # AllscriptsApi.configure do |config|
  #   config.app_name = 'YOUR_APP_NAME_HERE'
  #   config.app_username = 'YOUR_APP_USERNAME_HERE'
  #   config.app_password = 'YOUR_APP_PASSWORD_HERE'
  #   config.unity_url = 'CHOSEN_UNITY_URL'
  #   config.faraday_adapter = Faraday.some_adapter # default = Faraday.default_adapter
  # end
  class Configuration
    attr_accessor :app_name, :app_password, :unity_url,
                  :app_username, :faraday_adapter

    def initialize
      @app_name = ENV["app_name"]
      @app_password = ENV["app_password"]
      @unity_url = ENV["unity_url"]
      @app_username = ENV["app_username"]
      @faraday_adapter = Faraday.default_adapter
    end
  end
end
