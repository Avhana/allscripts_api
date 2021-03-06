# frozen_string_literal: true

RSpec.describe AllscriptsApi::MagicParams do
  describe "#format" do
    let(:empty_params_hash) do
      {
        AppUserID: "", PatientID: "",
        Parameter1: "", Parameter2: "",
        Parameter3: "", Parameter4: "",
        Parameter5: "", Parameter6: "",
        Data: {}
      }
    end

    let(:filled_params) do
      empty_params_hash[:Parameter4] = "some_data"
      empty_params_hash
    end

    it "builds a blank params hash" do
      expect(AllscriptsApi::MagicParams.format).to eq(empty_params_hash)
    end

    it "builds a params hash from partial set of params" do
      expect(
        AllscriptsApi::MagicParams.format(parameter4: "some_data")
      ).to eq(filled_params)
    end
  end
end
