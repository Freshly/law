# frozen_string_literal: true

RSpec.describe AdminIndexLaw, type: :law do
  it { is_expected.to inherit_from Law::LawBase }
  it { is_expected.to have_description "Restricts listing of sensitive objects intended only for Administrators." }

  it { is_expected.to impose_regulations DoAnythingRegulation, AdministrativeRegulation }
end
