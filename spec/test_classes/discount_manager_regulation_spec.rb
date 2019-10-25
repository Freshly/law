# frozen_string_literal: true

RSpec.describe DiscountManagerRegulation, type: :regulation do
  subject { described_class }

  it { is_expected.to inherit_from Law::RegulationBase }
  it { is_expected.to have_description "Restriction with limitations on the terms and conditions of discounts." }

  it { is_expected.to be_imposed_by CreateDiscountLaw }

  describe "Validations" do
    it "needs shoulda matchers to know regulations are models; and specs"
  end
end
