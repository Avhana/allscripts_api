# frozen_string_literal: true

RSpec.describe AllscriptsApi::NamedMagicMethods do
  before do
    check_and_load_secrets
  end

  it 'does something', skip: @if_no_secrets do
    expect(true).to eq(false)
  end
end
