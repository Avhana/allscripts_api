RSpec.describe AllscriptsApi::Configuration do

  describe "#new" do
    context "with env set" do
      before do 
        ENV["unity_url"] ||= "http://twlatestga.unitysandbox.com/"
      end

      let(:subject) { AllscriptsApi::Configuration.new }

      it "pulls configuration from the environment" do
        expect(subject.unity_url).to eq(ENV["unity_url"])
      end
    end

    context "without the env set" do
      before do
        ENV["unity_url"] = nil
      end
      after do
        ENV["unity_url"] = "http://twlatestga.unitysandbox.com/"
      end
      let(:subject) { AllscriptsApi::Configuration.new }

      it "configuration is nil" do
        expect(subject.unity_url).to eq(nil)
      end
    end
  end
end
