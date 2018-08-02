RSpec.describe AllscriptsApi::Orders::Order do
  describe "#self.build_xml" do
    let(:expected) do
      File.read("spec/fixtures/sample_order.xml")
    end

    let(:subject) do
      AllscriptsApi::Orders::Order.build_xml(3, 82, Date.parse("19-Apr-2018"), 52530)
    end

    it "returns formatted SendOrder xml" do
      expect(subject).to eq(expected)
    end
  end
end
