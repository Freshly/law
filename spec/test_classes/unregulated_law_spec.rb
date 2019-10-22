# frozen_string_literal: true

RSpec.describe UnregulatedLaw, type: :law do
  it { is_expected.to inherit_from Law::LawBase }
  it { is_expected.to have_description "Apply no restrictions to actions which can be performed by guests." }

  it { is_expected.to be_unregulated }
end
