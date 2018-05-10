# frozen_string_literal: true

RSpec.describe AllscriptsApi::Documents::DocumentSender do
  # Note: skip: @if_no_secrets causes a describe block to be skipped if
  # the environment isn't properly set up.
  before do
    WebMock.allow_net_connect!
    check_and_load_secrets
    @client = build_and_auth_client
  end

  after do
    WebMock.disable_net_connect!
  end

  describe "#sending an order", skip: @if_no_secrets do
    let(:subject) do
      AllscriptsApi::Documents::DocumentSender.new(@client, document, "test.pdf", params)
    end

    context "with params" do
      let(:document) { File.read("spec/fixtures/hba1c_sample.pdf") }
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

      it "returns a document id" do
        sender = subject
        result = sender.send_document[0]
        expect(result.keys).to include("documentID")
        expect(result["documentID"]).to_not eq("")
      end
    end

    context "with invalid params" do
      let(:document) { File.read("spec/fixtures/hba1c_sample.pdf") }
      let(:params) do
        { some_params: "bad data" }
      end

      it "raises an error without valid params" do
        expect { subject.send_document }.to raise_error(AllscriptsApi::MissingRequiredParamsError)
      end
    end
  end
end

