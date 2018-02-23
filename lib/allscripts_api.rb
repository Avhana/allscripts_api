# frozen_string_literal: true

require "allscripts_api/configuration"
require "allscripts_api/magic_params"
require "allscripts_api/named_magic_methods"
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

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= AllscriptsApi::Configuration.new
      yield(configuration)
    end

    def connect
      unity_url = AllscriptsApi.configuration.unity_url
      app_name = AllscriptsApi.configuration.app_name
      app_username = AllscriptsApi.configuration.app_username
      app_password = AllscriptsApi.configuration.app_password

      Client.new(unity_url, app_name, app_username, app_password)
    end
  end
end
