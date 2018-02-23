# frozen_string_literal: true
require "allscripts_api/magic_params"
require "allscripts_api/named_magic_methods"
require "allscripts_api/client"
require "allscripts_api/version"
require "allscripts_api/configuration"

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
  end

  def self.configure
    self.configuration ||= AllscriptsApi::Configuration.new
    yield(configuration)
  end
end
