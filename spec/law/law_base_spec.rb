# frozen_string_literal: true

RSpec.describe Law::LawBase, type: :law do
  include_context "with an example law"

  it { is_expected.to inherit_from Spicerack::InputObject }

  it { is_expected.to include_module Law::Laws::Actions }
  it { is_expected.to include_module Law::Laws::Statutes }
  it { is_expected.to include_module Law::Laws::Petitions }
  it { is_expected.to include_module Law::Laws::Judgements }
end
