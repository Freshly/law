# frozen_string_literal: true

RSpec.describe AuthenticationLaw, type: :law do
  it { is_expected.to inherit_from CommonLaw }
  it { is_expected.to have_description "Restriction which requires an authenticated user." }

  it { is_expected.to impose_regulations DoAnythingRegulation, AuthenticationRegulation }
end
