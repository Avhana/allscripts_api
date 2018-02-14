# frozen_string_literal: true

RSpec.describe AllscriptsApi::NumberedParams do
  describe "format" do
    let(:empty_params_hash) do
      {
        Parameter1: "", Parameter2: "",
        Parameter3: "", Parameter4: "",
        Parameter5: "", Parameter6: ""
      }
    end

    let(:filled_params) do
      empty_params_hash[:Parameter4] = "some_data"
      empty_params_hash
    end

    it "builds a blank params hash" do
      expect(AllscriptsApi::NumberedParams.format).to eq(empty_params_hash)
    end

    it "builds a params hash from partial set of params" do
      expect(
        AllscriptsApi::NumberedParams.format(parameter4: "some_data")
      ).to eq(filled_params)
    end
  end
end
