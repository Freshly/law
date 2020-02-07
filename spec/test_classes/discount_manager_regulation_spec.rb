# frozen_string_literal: true

RSpec.describe DiscountManagerRegulation, type: :regulation do
  include_context "with an example petition"

  subject { described_class.new(petition: example_petition) }

  let(:discount_cents) { nil }
  let(:maximum_usages) { nil }
  let(:params) do
    { discount_cents: discount_cents, maximum_usages: maximum_usages }
  end

  it { is_expected.to inherit_from Law::RegulationBase }

  it { is_expected.to be_imposed_by CreateDiscountStatute }

  it { is_expected.to validate_numericality_of(:params_discount_cents).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:params_discount_cents).is_less_than_or_equal_to(2000) }
  it { is_expected.to validate_numericality_of(:params_discount_cents).only_integer }

  it { is_expected.to validate_numericality_of(:params_maximum_usages).is_greater_than_or_equal_to(1) }
  it { is_expected.to validate_numericality_of(:params_maximum_usages).is_less_than_or_equal_to(3) }
  it { is_expected.to validate_numericality_of(:params_maximum_usages).only_integer }
end
