# frozen_string_literal: true

RSpec.describe AllscriptsApi::Client do
  let(:app_name) { "test" }
  let(:url) { "http://someallscriptsurl.example" }
  let(:username) { "username" }
  let(:password) { "password" }
  let(:subject) do
    AllscriptsApi::Client.new(url, app_name, username, password)
  end

  describe "#new" do
    it "sets a default adapter" do
      expect(subject.adapter).to eq(:net_http)
    end

    it "assigns a URL" do
      expect(subject.unity_url).to eq(url)
    end

    it "assigns an app name" do
      expect(subject.app_name).to eq(app_name)
    end
  end

  let(:get_token_uri) { url + "/Unity/UnityService.svc/json/GetToken" }
  let(:token) { "BFB3B998-A668-4300-A48B-0977E3DFA108" }

  before do
    stub_request(:post, get_token_uri)
      .to_return(status: 200,
                 body: token,
                 headers: { "content-type" => "application/octet-stream" })
  end

  describe "#get_token" do
    it "sets a client token" do
      subject
      expect(subject.get_token).to eq(token)
      expect(subject.token).to eq(token)
    end
  end

  describe "#get_user_authentication" do
    before do
    end

    it "authenticates a security token to an Allscripts user" do
    end
  end

  describe "#validate_sso_token" do
    let(:magic_action_uri) { url + "/Unity/UnityService.svc/json/MagicJson" }
    let(:body) { "[{\"Table\":[{\"OrganizationName\":\"Touchworks\",\"PatientID\":\"321\",\"EncounterID\":\"54321\",\"CreatedOn\":\"03/02/2018 5:26:53 PM\",\"SSOUserName\":\"jmedici\"}]}]"  }

    before do
      stub_request(:post, magic_action_uri)
        .to_return(status: 200,
                   body: body,
                   headers: { "content-type" => "application/octet-stream" })
    end

    it "validates the sso token by returning the encounter context" do
      subject && subject.get_token
      expect(subject.validate_sso_token("some_token")).to eq(JSON.parse(body)[0]["Table"][0])
    end
  end

  describe "#magic" do
  end
end
