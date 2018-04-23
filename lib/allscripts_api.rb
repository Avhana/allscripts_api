# frozen_string_literal: true
require "nokogiri"
require "allscripts_api/configuration"
require "allscripts_api/magic_params"
require "allscripts_api/named_magic_methods"
require "allscripts_api/ordering_methods"
require "allscripts_api/order"
require "allscripts_api/client"
require "allscripts_api/version"

# Entry point for the AllscriptsApi gem.
module AllscriptsApi
  # Error wrapper of Unity or other Allscripts API errors.
  class MagicError < RuntimeError
  end

  # Error raised whenever Unity's '/GetToken' call fails or returns an error.
  class GetTokenError < RuntimeError
  end

  # Error raised if AllscriptsApi.connect is called without configuring
  # the gem first
  class NoConfigurationError < RuntimeError
    # method to return a sample config block
    #
    # @return [String] a sample config block
    def self.error_message
      %(Please add the following to config/initializers and try again.
        AllscriptsApi.configure do |config|
          config.app_name = 'YOUR_APP_NAME_HERE'
          config.app_username = 'YOUR_APP_USERNAME_HERE'
          config.app_password = 'YOUR_APP_PASSWORD_HERE'
        end
      )
    end
  end

  class << self
    attr_accessor :configuration
    # a method that allows a configuration block to be passed
    # to AllscriptsApi::Configuration#new
    # @see AllscriptsApi::Configuration
    def configure
      self.configuration ||= AllscriptsApi::Configuration.new
      yield(configuration)
    end

    # The main entry point for a pre-configured client
    #
    # @param unity_url [String] Unity API endpoint to connect to
    # @return [AllscriptsApi::Client, AllscriptsApi::NoConfigurationError]
    # @see AllscriptsApi::Client
    def connect(unity_url)
      unless AllscriptsApi.configuration
        raise NoConfigurationError, NoConfigurationError.error_message
      end
      app_name = AllscriptsApi.configuration.app_name
      app_username = AllscriptsApi.configuration.app_username
      app_password = AllscriptsApi.configuration.app_password

      Client.new(unity_url, app_name, app_username, app_password)
    end
  end
end
