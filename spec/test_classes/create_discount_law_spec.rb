# frozen_string_literal: true

RSpec.describe CreateDiscountLaw, type: :law do
  it { is_expected.to inherit_from CommonLaw }
  it { is_expected.to have_description "Restriction around the terms and conditions of discount creation." }

  it { is_expected.to impose_regulations DiscountAdministratorRegulation, DiscountManagerRegulation }
end
