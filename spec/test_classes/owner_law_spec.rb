# frozen_string_literal: true

RSpec.describe OwnerLaw, type: :law do
  it { is_expected.to inherit_from CommonLaw }
  it { is_expected.to have_description "Restriction which requires an actor which owns the target." }

  it { is_expected.to impose_regulations DoAnythingRegulation, AdministrativeRegulation, OwnerRegulation }
end
