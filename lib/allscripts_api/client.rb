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
      if response.status == 200
        @token = response.body
      else
        raise GetTokenError, response.body
      end
    end

    def validate_sso_token(sso_token, unity_url, token)
    end

    def magic(action, patient_id, numbered_params: NumberedParams.format())
      full_path = build_request_path("/MagicJson")
      body = build_magic_body(action, patient_id, numbered_params)
      conn = build_conn
      response =
        conn.post do |req|
          req.url(full_path)
          req.body = body
        end
      response.body
    end

    def read_magic_response(response)
    end

    def build_magic_body(action, patient_id, numbered_params)
      numbered_params.merge!(
        Action: action,
        Appname: @app_name,
        AppUserID: @username,
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
