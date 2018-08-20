# frozen_string_literal: true

require "faraday"
require "json"
module AllscriptsApi
  # Client serves as an entry point for making calls
  class Client
    include AllscriptsApi::NamedMagicMethods
    include AllscriptsApi::Orders::OrderingMethods
    include AllscriptsApi::Patients::PatientMethods
    include AllscriptsApi::Demographics::DemographicsMethods
    include AllscriptsApi::Documents::DocumentMethods
    attr_reader :adapter, :unity_url, :app_name, :token
    attr_writer :sso_token

    # hardcoded to use the JSON endpoint
    ENDPOINT = "/UnityService.svc/json".freeze

    # Instantiation of the Client
    #
    # @param url [String] Allscripts URL to be used to make Unity API calls
    # @param app_name [String] app name assigned by Allscripts
    # @param app_username [String] the app username supplied by Allscripts
    # @param app_password [String] the app password supplied by Allscripts
    def initialize(url, app_name, app_username, app_password)
      @unity_url = url
      @app_name = app_name
      @username = app_username
      @password = app_password
      @adapter = check_adapter
    end

    # Gets security token necessary in all workflows
    # @return [String] security token
    def get_token
      full_path = build_request_path("/GetToken")
      response = conn.post do |req|
        req.url(full_path)
        req.body = { Username: @username, Password: @password }.to_json
      end

      raise(GetTokenError, response.body) unless response.status == 200
      @token = response.body
    end

    # Assign a security token from `get_token` to a specific Allscripts user.
    # This creates a link on the Allscripts server that allows that token
    # to be used in subsequent `magic` calls passed that user's username.
    #
    # @param username [String] the Allscripts user's username (from Allscripts)
    # @param password [String] the Allscripts user's password (from Allscripts)
    # @return [Hash] user permissions, etc.
    def get_user_authentication(username, password)
      @allscripts_username = username
      params = MagicParams.format(user_id: username, parameter1: password)
      response = magic("GetUserAuthentication", magic_params: params)
      response["getuserauthenticationinfo"][0]
    end

    # Validate a token generated and passed by Allscripts during SSO
    # Falls back and looks for sso_token on the client if not passed one
    # Note that sso_token is not the token from `get_token``
    #
    # TODO: test and validate. Add error handling
    #
    # @param sso_token [String] the Allscripts SSO token (from Allscripts)
    def validate_sso_token(sso_token = nil)
      sso_token ||= @sso_token
      params = MagicParams.format(parameter1: sso_token)
      response = magic("GetTokenValidation", magic_params: params)
      response["Table"][0]
    end

    # Main method for interacting with the Allscripts UnityAPI
    #
    # @param action [String] the API action to be performed
    # @param magic_params [MagicParams] a params object
    # used to build the Magic Action request body's user_id,
    # patient_id, and magic parameters. The patient_id
    # is sometimes oprional and the numbered
    # params are generally optional, but must be sent
    # as blank strings if unused.
    # @return [Hash, MagicError] the parsed JSON response from Allscripts or
    # a `MagicError` with the API error message(hopefully)
    def magic(action, magic_params: MagicParams.format)
      full_path = build_request_path("/MagicJson")
      body = build_magic_body(action, magic_params)
      response =
        conn.post do |req|
          req.url(full_path)
          req.body = body
        end
      read_magic_response(action, response)
    end

    private

    def check_adapter
      @adapter ||=
        if AllscriptsApi.configuration
          AllscriptsApi.configuration.faraday_adapter
        else
          Faraday.default_adapter # make requests with Net::HTTP
        end
    end

    def read_magic_response(action, response)
      raise(MagicError, response.body) unless response.status == 200
      response_body = JSON.parse(response.body)[0]
      raise(MagicError, response_body["Error"]) if response_body.key?("Error")
      begin
        status = response_body[(action.downcase + "info")].first["STATUS"]
        raise(MagicError, status) if status.include?("Critical")
      rescue NoMethodError
        response_body
      end
    end

    def build_magic_body(action, params)
      params.merge(
        Action: action,
        Appname: @app_name,
        Token: @token
      ).to_json
    end

    def build_request_path(path)
      "#{ENDPOINT}#{path}"
    end

    def conn
      @conn ||= Faraday.new(url: @unity_url) do |faraday|
        faraday.headers["Content-Type"] = "application/json"
        faraday.adapter(@adapter)
      end
    end
  end
end
