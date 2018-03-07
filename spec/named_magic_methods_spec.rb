# frozen_string_literal: true

RSpec.describe AllscriptsApi::NamedMagicMethods do
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

  describe "#search_patients", skip: @if_no_secrets do
    let(:subject) { @client.search_patients(search_string) }
    context "by last name, with results" do
      let(:search_string) { "Allscripts" }
      it "fetches patients with the last name 'Allscripts'" do
        subject
        expect(subject.length).to be > 1
        expect(subject[0]["lastname"]).to eq(search_string)
      end
    end

    context "with no results" do
      let(:search_string) { "some useless, long query" }
      it "returns an empty array" do
        subject
        expect(subject.length).to eq(0)
      end
    end
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
  end

  describe "#get_patient", skip: @if_no_secrets do
    let(:subject) { @client.get_patient(patient_id) }
    context "by patient id" do
      let(:patient_id) { 31 }

      it "fetches patient demographic info for specified patient" do
        subject
        expect(subject).to_not be_nil
        expect(subject[0].keys).to include("ZipCode")
      end
    end
  end

  describe "#get_patient_problems", skip: @if_no_secrets do
    let(:subject) { @client.get_patient_problems(patient_id) }
    context "by patient id only" do
      let(:patient_id) { 31 }
      it "fetches problems for the specified patient" do
        subject
        expect(subject.length).to be >= 1
        expect(subject.map { |prob| prob["problemtext"] }).to include("Atrial fibrillation")
      end
    end

    context "with no results" do
      let(:patient_id) { 0 }
      it "raises an error when Allscripts returns an id error" do
        expect { subject }.to raise_error(AllscriptsApi::MagicError)
      end
    end
  end
end
