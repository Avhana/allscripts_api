# frozen_string_literal: true

RSpec.describe AllscriptsApi::Client do
  let(:app_name) { "test" }
  let(:url) { "http://someallscriptsurl.example" }
  let(:username) { "username" }
  let(:password) { "password" }
  let(:subject) do
    AllscriptsApi::Client.new(app_name, url, username, password)
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

  describe "#get_token" do
    before do
      full_uri = "http://unitysandbox.example/Unity/UnityService.svc/json/GetToken"
      stub_request(:post, full_uri)
        .to_return(status: 200,
                   body: "BFB3B998-A668-4300-A48B-0977E3DFA108",
                   headers: { "content-type" => "application/octet-stream" })
    end
    let(:url) { "http://unitysandbox.example" }
    let(:token) { "BFB3B998-A668-4300-A48B-0977E3DFA108" }

    it "sets a client token" do
      subject
      expect(subject.get_token).to eq(token)
      expect(subject.token).to eq(token)
    end
  end

  describe "#magic" do
  end
end
