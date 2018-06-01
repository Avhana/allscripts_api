# frozen_string_literal: true

RSpec.describe AllscriptsApi::Patients::PatientMethods do
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

  describe "#get_clinical_summary", skip: @if_no_secrets do
    let(:subject) { @client.get_clinical_summary(patient_id) }
    context "by patient id" do
      let(:patient_id) { 31 }

      it "fetches clinical summary for specified patient and encounter" do
        subject
        expect(subject).to_not be_nil
        expect(subject[0].keys).to include("detail")
      end
    end

    context "without required data" do
      let(:patient_id) { 0 }

      it "raises an error without a valid patient id" do
        expect { subject }.to raise_error(AllscriptsApi::MagicError)
      end
    end
  end

  describe "#get_changed_patients", skip: @if_no_secrets do
    let(:subject) { @client.get_changed_patients(patient_id, date) }
    context "with a valid patient id" do
      let(:patient_id) { 17 }
      let(:date) { DateTime.now }

      it "fetches change data" do
        subject
        expect(subject).to_not be_nil
      end
    end

    context "without an invalid patient id" do
      let(:patient_id) { nil }
      let(:date) { DateTime.now }

      it "returns a status error without a valid patient id" do
        status_error = {
        "status" => "Error converting data type varchar to numeric."
        }
        expect(subject[0]).to eq(status_error)
      end
    end
  end
end

