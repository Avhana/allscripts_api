RSpec.describe AllscriptsApi do
  it "has a version number" do
    expect(AllscriptsApi::VERSION).not_to be nil
  end
  
  describe "#configure" do
    let(:subject) do
      AllscriptsApi.configure do |config|
        config.app_name = "Testy.McTestApp"
        config.app_password = "test1234"
        config.unity_url = "http://test.example"
        config.app_username = "testy"
      end
    end

    it "sets config values" do
      subject
      expect(AllscriptsApi.configuration.app_name).to eq("Testy.McTestApp")
      expect(AllscriptsApi.configuration.app_password ).to eq("test1234")
      expect(AllscriptsApi.configuration.unity_url ).to eq("http://test.example")
      expect(AllscriptsApi.configuration.app_username ).to eq("testy")
    end
  end
end
