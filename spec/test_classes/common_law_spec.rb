# frozen_string_literal: true

RSpec.describe CommonLaw, type: :law do
  it { is_expected.to inherit_from Law::LawBase }
  it { is_expected.to have_description "Restrictions which apply to all actions." }

  it { is_expected.to impose_regulations DoAnythingRegulation }
end
