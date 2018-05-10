# frozen_string_literal: true

module AllscriptsApi
  # Configuration class to allow configuration on application
  # initialization. Configuration should look like the following.
  #
  #   AllscriptsApi.configure do |config|
  #     config.app_name = 'YOUR_APP_NAME_HERE'
  #     config.app_username = 'YOUR_APP_USERNAME_HERE'
  #     config.app_password = 'YOUR_APP_PASSWORD_HERE'
  #     config.faraday_adapter = Faraday.some_adapter # default = Faraday.default_adapter
  #   end
  class Configuration
    attr_accessor :app_name, :app_password, :app_username, :faraday_adapter
    # The initialize method may be passed a block, but defaults to fetching
    # data from the environment
    #
    # @return [AllscriptsApi:Configuration] new instance of the config class
    def initialize
      @app_name = ENV["app_name"]
      @app_password = ENV["app_password"]
      @app_username = ENV["app_username"]
      @faraday_adapter = Faraday.default_adapter
    end
  end
end
