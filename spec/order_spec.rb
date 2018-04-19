RSpec.describe AllscriptsApi::Order do
  describe "#self.build_xml" do
    let(:expected) do
      File.read("spec/fixtures/sample_order.xml")
    end
    
    let(:subject) do 
      AllscriptsApi::Order.build_xml(1, 2, Date.today)
    end

    it "returns formatted SendOrder xml" do
      expect(subject).to eq(expected)
    end
  end
end
