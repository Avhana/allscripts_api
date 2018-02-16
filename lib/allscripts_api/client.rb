# frozen_string_literal: true

require "faraday"
require "json"
module AllscriptsApi
  # Client serves as an entry point for making calls
  class Client
    attr_reader :adapter, :unity_url, :app_name, :token
    ENDPOINT = "/Unity/UnityService.svc/json".freeze

    def initialize(app_name, url, username, password)
      @adapter = Faraday.default_adapter # make requests with Net::HTTP
      @username = username
      @password = password
      @unity_url = url
      @app_name = app_name
    end

    # Gets security token necessary in all workflows
    # @return [String] security token
    def get_token
      full_path = build_request_path("/GetToken")
      response = build_conn.post do |req|
        req.url(full_path)
        req.body = { Username: @username, Password: @password }.to_json
      end

      raise(GetTokenError, response.body) unless response.status == 200
      @token = response.body
    end

    # Used to assign a token from `get_token` to a specific Allscripts
    # user. This creates a link on the Allscripts server that allows
    # that token to be used for subsequent `magic` calls that are passed
    # that user's username.
    #
    # @param username [String] the Allscripts user's username (from Allscripts)
    # @param password [String] the Allscripts user's password (from Allscripts)
    # @return [Hash] user permissions, etc.
    def get_user_authentication(username, password)
      params = NumberedParams.format(parameter1: password)
      magic("GetUserAuthentication", username, "", params: params)
    end

    # def validate_sso_token(sso_token, unity_url, token)
    # end

    # Main method for interacting with the Allscripts UNityAPI
    #
    # @param action [String] the API action to be performed
    # @param patient_id [String] optional patient ID for some
    # api calls related to specific patients
    # @param params [NumberedParams] a numbered params object
    # used to build the Magic Action request body's numbered
    # parameters. They are generally optional, but must be sent
    # as blank strings if unused.
    # @return [Hash] the parsed JSON response from Allscripts
    def magic(action, user_id, patient_id, params: NumberedParams.format)
      full_path = build_request_path("/MagicJson")
      body = build_magic_body(action, user_id, patient_id, params)
      conn = build_conn
      response =
        conn.post do |req|
          req.url(full_path)
          req.body = body
        end

      read_magic_response(response)
    end

    private

    def read_magic_response(response)
      raise(MagicError, response.body) unless response.status == 200
      JSON.parse(response.body)[0]
    end

    def build_magic_body(action, user_id, patient_id, params)
      params.merge(
        Action: action,
        Appname: @app_name,
        AppUserID: user_id,
        PatientID: patient_id,
        Token: @token,
        Data: ""
      ).to_json
    end

    def build_request_path(path)
      "#{ENDPOINT}#{path}"
    end

    def build_conn
      Faraday.new(url: @unity_url) do |faraday|
        faraday.headers["Content-Type"] = "application/json"
        faraday.adapter(@adapter)
      end
    end
  end
end
