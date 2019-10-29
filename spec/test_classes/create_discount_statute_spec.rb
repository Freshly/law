# frozen_string_literal: true

RSpec.describe CreateDiscountStatute, type: :statute do
  it { is_expected.to inherit_from CommonStatute }

  it { is_expected.to impose_regulations DiscountAdministratorRegulation, DiscountManagerRegulation }
  it { is_expected.to be_enforced_by DiscountLaw, :new, :create }
end
