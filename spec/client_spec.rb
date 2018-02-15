# frozen_string_literal: true

RSpec.describe AllscriptsApi::Client do
  let(:app_name) { "test" }
  let(:url) { "http://soeallscriptsurl.example" }
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

  describe "#build_request_path" do
    let(:path) { "/GetToken" }
    let(:expected) { "/Unity/UnityService.svc/json/GetToken"}

    it "builds a valid request path" do
      expect(subject.build_request_path(path)).to eq(expected)
    end
  end
end
