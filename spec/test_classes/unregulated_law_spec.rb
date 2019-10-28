# frozen_string_literal: true

RSpec.describe UnregulatedLaw, type: :law do
  it { is_expected.to inherit_from Law::LawBase }

  it { is_expected.to be_unregulated }
end
