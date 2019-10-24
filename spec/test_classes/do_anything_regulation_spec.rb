# frozen_string_literal: true

RSpec.describe DoAnythingRegulation, type: :regulation do
  subject { described_class }

  it { is_expected.to inherit_from Law::RegulationBase }
  it { is_expected.to have_description "You can't just do anything! Fundamental restriction against anonymous access." }

  it { is_expected.to be_imposed_by CommonLaw }
end
