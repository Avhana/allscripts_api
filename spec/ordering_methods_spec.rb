# frozen_string_literal: true

RSpec.describe AllscriptsApi::OrderingMethods do
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

  describe "#save_order", skip: @if_no_secrets do
    let(:subject) { @client.save_order(19, xml, "ProcedureOrder", order_id) }
    
    context "with valid xml, order_id, etc" do
      let(:xml) do
        File.read("spec/fixtures/sample_order.xml")
      end
      let(:order_id) { 1054 }

      it "returns a success message" do
        subject
        expect(subject["saveorderinfo"][0]["status"]).to eq("Success")
      end
    end

    context "with invalid xml" do
      let(:xml) { "<xml><saveorderxml>invalid</saveorderxml></xml>" }
      let(:order_id) { 1054 }
      it "raises an error without valid xml" do
        expect { subject }.to raise_error(AllscriptsApi::MagicError)
      end
    end
  end
end

