# frozen_string_literal: true

RSpec.describe AllscriptsApi::Utilities::Validator do
  describe "#self.build_xml" do
    let(:required) do
      [:one, :two, :three]
    end

    let(:subject) do
      AllscriptsApi::Utilities::Validator.validate_params(required, params)
    end

    context "missing params" do
      let(:params) do 
        {two: 2, three: 3}
      end

      it "raises an error with the missing params in the message" do
        expect { subject }.to raise_error(
          AllscriptsApi::MissingRequiredParamsError, "The key(s) [:one] is/are required for this method."
        )
      end
    end
    context "with valid params" do
      let(:params) do 
        {one: 1, two: 2, three: 3}
      end

      it "returns nil, and does not raise" do
        expect(subject).to eq(nil)
      end
    end
  end
end
