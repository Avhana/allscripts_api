# frozen_string_literal: true

RSpec.describe AllscriptsApi::Documents::DocumentMethods do
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

  describe "#get_ccda", skip: @if_no_secrets do
    let(:subject) { @client.get_ccda(patient_id, encounter_id) }
    context "by patient id and encounter id" do
      let(:encounter_id) { 1 }
      let(:patient_id) { 31 }

      it "fetches a ccda for the specified patient and encounter" do
        subject
        xml = Nokogiri::XML(subject).remove_namespaces!
        expect(xml).to_not be_nil
        last_name = xml.xpath("//patient/name/family").text
        expect(last_name).to eq("Allscripts")
      end
    end

    context "without required data" do
      let(:patient_id) { 31 }
      let(:encounter_id) { "" }

      it "raises an error without a valid encounter" do
        expect { subject }.to raise_error(AllscriptsApi::MagicError)
      end
    end
  end
end

