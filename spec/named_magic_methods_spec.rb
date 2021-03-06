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

  describe "#get_provider", skip: @if_no_secrets do
    let(:subject) { @client.get_provider(id, user_name) }
    context "by user_name, with results" do
      let(:id) { "" }
      let(:user_name) { "jmedici" }
      it "finds records for jmedici" do
        subject
        expect(subject[0]["FirstName"]).to eq("James")
      end
    end

    context "with no params" do
      let(:id) { "" }
      let(:user_name) { "" }

      it "raises an error" do
        expect { subject }.to raise_error(AllscriptsApi::MagicError)
      end
    end
  end

  describe "#get_providers", skip: @if_no_secrets do
    let(:subject) { @client.get_providers() }
    context "gets full list of providers" do
      it "finds records for jmedici" do
        subject
        expect(subject.length).to be >= 75
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
        expect(subject.map { |prob| prob["problemtext"] }).to include("Former Smoker")
      end
    end

    context "with no results" do
      let(:patient_id) { 0 }
      it "raises an error when Allscripts returns an id error" do
        expect { subject }.to raise_error(AllscriptsApi::MagicError)
      end
    end
  end

  describe "#get_results", skip: @if_no_secrets do
    let(:subject) { @client.get_results(patient_id) }
    context "by patient id only" do
      let(:patient_id) { 31 }
      it "fetches problems for the specified patient" do
        subject
        expect(subject.length).to be >= 1
        expect(subject.map { |prob| prob["Name"] }).to include("HDL")
      end
    end

    context "with no results" do
      let(:patient_id) { 0 }
      it "returns an empty list if patient is not recognized by Allscripts" do
        expect(subject.length).to eq(0)
      end
    end

    context "with bad patient" do
      let(:patient_id) { "asdfsd" }
      it "raises an error when Allscripts returns an id error" do
        expect { subject }.to raise_error(AllscriptsApi::MagicError)
      end
    end
  end

  describe "#get_schedule", skip: @if_no_secrets do
    let(:subject) { @client.get_schedule(start_date, end_date) }
    context "with results" do
      let(:start_date) { Date.parse("May 3 2016") }
      let(:end_date) { Date.parse("May 8 2018") }

      it "parses appointments into an array of hashes" do
        expect(subject.length).to be > 1
      end
    end

    context "with no results" do
      let(:start_date) { Date.parse("May 1 2016") }
      let(:end_date) { Date.parse("May 1 2016") }

      it "returns empty array" do
        expect(subject.length).to be 0
      end
    end

    context "with an other_username" do
      let(:start_date) { Date.parse("May 1 2016") }
      let(:end_date) { Date.parse("May 8 2018") }
      let(:other_username) { "jmedici" }


      it "returns empty array" do
        @client.get_schedule(start_date, end_date, other_username)
        expect(subject.length).to eq(6)
      end
    end
  end

  describe "#get_list_of_dictionaries", skip: @if_no_secrets do
    let(:subject) { @client.get_list_of_dictionaries }
    it "fetches a list of dictionaries" do
      subject
      expect(subject.length).to be >= 1
      dictionary_list_item = {"TableName"=>"Code_Type_DE", "DictionaryName"=>"Code Type"}
      expect(subject).to include(dictionary_list_item)
    end
  end

  describe "#search_delegates", skip: @if_no_secrets do
    let(:subject) { @client.search_delegates("jmedici") }
    it "fetches delegates" do
      subject
      expect(subject.length).to be == 47
      expect(subject.first["DelegateID"]).to eq("Userjmedici")
    end
  end

  describe "#get_delegates", skip: @if_no_secrets do
    let(:subject) { @client.get_delegates }
    it "fetches delegates" do
      subject
      expect(subject.length).to be == 29
      expect(subject.first["DelegateID"]).to eq("Team14")
    end
  end

  # Can't find a good patient to test with
  describe "#get_patient_pharmacies", skip: @if_no_secrets do
    let(:subject) { @client.get_patient_pharmacies("29") }
    it "fetches delegates" do
      subject
      expect(subject.length).to be == 0
    end
  end

  describe "#save_task", skip: @if_no_secrets do
    let(:subject) { @client.save_task("ViewNote", "jmedici") }
    it "fetches delegates" do
      subject
      expect(subject.first["status"]).to eq("success")
    end
  end

  describe "#get_dictionary", skip: @if_no_secrets do
    let(:subject) { @client.get_dictionary(dictionary_name) }
    let(:example_data) do
      {"SiteDE_Active"=>" ",
        "EntryCode"=>"CPT",
        "SiteDE_Entryname"=>"",
        "EntryMnemonic"=>"CPT",
        "SiteDE_Entrymnemonic"=>"",
        "SiteDE_ID"=>"0",
        "ID"=>"3",
        "Dictionary"=>"Code_Type_DE",
        "SiteDE_EntryCode"=>"",
        "EntryName"=>"CPT",
        "Active"=>"Y"}
    end

    context "with a valid name" do
      let(:dictionary_name) { "Code_Type_DE" }

      it "fetches dictionary codes" do
        subject
        expect(subject.length).to be >= 1
        expect(subject).to include(example_data)
      end
    end

    context "with an ivalid name" do
      let(:dictionary_name) { "OECD" }

      it "returns an error" do
        expect { subject }.to raise_error(AllscriptsApi::MagicError)
      end
    end
  end
end
