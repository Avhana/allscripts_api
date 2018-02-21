# frozen_string_literal: true

RSpec.describe AllscriptsApi::NamedMagicMethods do
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
end
