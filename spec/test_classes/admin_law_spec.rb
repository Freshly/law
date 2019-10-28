# frozen_string_literal: true

RSpec.describe AdminLaw, type: :law do
  it { is_expected.to inherit_from Law::LawBase }

  it { is_expected.to impose_regulations DoAnythingRegulation, AdministrativeRegulation }
end
