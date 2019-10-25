# frozen_string_literal: true

RSpec.describe DiscountAdministratorRegulation, type: :regulation do
  subject { described_class }

  it { is_expected.to inherit_from Law::RegulationBase }
  it { is_expected.to have_description "Restriction with no limitations on the terms and conditions of discounts." }

  it { is_expected.to be_imposed_by CreateDiscountLaw }
end
