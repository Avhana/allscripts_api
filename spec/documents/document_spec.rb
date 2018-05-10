# frozen_string_literal: true

RSpec.describe AllscriptsApi::Documents::Document do
  describe "#self.build_xml" do
    let(:expected) do
      File.read("spec/fixtures/document.xml")
    end

    let(:params) do
      {
        bytes_read: "0",
        b_done_upload: false,
        document_var: "",
        patient_id: 19,
        owner_code: "TW0001",
        first_name: "Allison",
        last_name: "Allscripts",
        document_type: "sEKG",
        # this is an optional field, but gets generated if not supplied
        encounter_time: "2018-05-10 18:05:30",
        organization_name: "New World Health"
      }
    end

    let(:subject) do
      AllscriptsApi::Documents::Document.build_xml("test.pdf", "i", params)
    end

    it "returns formatted SaveDocumentImage xml" do
      expect(subject).to eq(expected)
    end
  end
end
