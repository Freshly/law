# frozen_string_literal: true

RSpec.describe CreateDiscountLaw, type: :law do
  it { is_expected.to inherit_from CommonLaw }

  it { is_expected.to impose_regulations DiscountAdministratorRegulation, DiscountManagerRegulation }
end
