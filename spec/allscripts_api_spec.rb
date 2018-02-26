RSpec.describe AllscriptsApi do
  it "has a version number" do
    expect(AllscriptsApi::VERSION).not_to be nil
  end

  describe "#self.connect" do
  let(:subject) { AllscriptsApi.connect }
    context "without configuration" do
      it "raises an error" do
        expect { subject }.to raise_error(AllscriptsApi::NoConfigurationError)
      end
    end
    context "with configuration" do
      let!(:config) do
        AllscriptsApi.configure do |config|
          config.app_name = "Testy.McTestApp"
          config.app_password = "test1234"
          config.unity_url = "http://test.example"
          config.app_username = "testy"
        end
      end

      it "returns a client" do
        expect(subject).to be_an_instance_of(AllscriptsApi::Client)
      end
    end
  end

  describe AllscriptsApi::NoConfigurationError do
    describe "#self.error_message" do
      let(:subject) { AllscriptsApi::NoConfigurationError.error_message }
      it "returns a warning message" do
        expect(subject).to match(/Please add the following to config/)
      end
    end
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
