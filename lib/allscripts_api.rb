# frozen_string_literal: true

require "allscripts_api/client"
require "allscripts_api/numbered_params"
require "allscripts_api/version"

# Entyr point for the AllscriptsApi gem.
module AllscriptsApi
  # Error wrapper of Unity or other Allscripts API errors.
  class APIError < RuntimeError
  end

  # Error raised whenever Unity's '/GetToken' call fails or returns an error.
  class GetTokenError < RuntimeError
  end

  def new(options = {})
    Client.new(nil, nil, nil)
  end
end
