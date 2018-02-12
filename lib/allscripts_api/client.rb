# frozen_string_literal: true

module AllscriptsApi
  class Client
    def new(unity_endpoint, username, password)
      @adapter = Faraday.default_adapter # make requests with Net::HTTP
      @username = username
      @password = password
      @unity_endpoint = @unity_endpoint
    end

    # Gets security token necessary in all workflows
    # @return [String] security token
    def token
      conn = build_conn
      response = 
        conn.post do |req|
          req.basic_auth(@username, @password)
          req.url("/GetToken")
        end
      response.body
    end

    def validate_sso_token(sso_token, unity_endpoint, token)
    end

    def magic(action:, allscripts_user_id: "", allscripts_patient_id: "", numbered_params: NumberedParams.format(), allscripts_url:, token:)
      conn = build_conn
      response = 
        conn.post do |req|
          # use toke, app name, app id, numbered params, etc
        end
      response.body
    end

    def read_magic_response(response)
    end

    def build_conn
      Faraday.new(url: @unity_endpoint) do |faraday|
        faraday.adapter(@adapter)
      end
    end
  end
end