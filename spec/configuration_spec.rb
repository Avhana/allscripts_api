RSpec.describe AllscriptsApi::Configuration do

  describe "#new" do
    context "with env set" do
      before do 
        ENV["app_name"] ||= "Allscripts App Name"
      end

      let(:subject) { AllscriptsApi::Configuration.new }

      it "pulls configuration from the environment" do
        expect(subject.app_name).to eq(ENV["app_name"])
      end
    end

    context "without the env set" do
      before do
        @old_app_name = ENV["app_name"]
        ENV["app_name"] = nil
      end
      after do
        ENV["app_name"] = @old_app_name
      end
      let(:subject) { AllscriptsApi::Configuration.new }

      it "configuration is nil" do
        expect(subject.app_name).to eq(nil)
      end
    end
  end
end
