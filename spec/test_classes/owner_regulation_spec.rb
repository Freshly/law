# frozen_string_literal: true

RSpec.describe OwnerRegulation, type: :regulation do
  subject { described_class }

  it { is_expected.to inherit_from Law::RegulationBase }
  it { is_expected.to have_description "Restriction requiring the current actor to own the object being modified." }

  it { is_expected.to be_imposed_by OwnerLaw }
end
