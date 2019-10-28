# frozen_string_literal: true

RSpec.describe AdministrativeRegulation, type: :regulation do
  subject { described_class }

  it { is_expected.to inherit_from Law::RegulationBase }

  it { is_expected.to be_imposed_by AdminLaw, OwnerLaw }
end
