# frozen_string_literal: true

RSpec.describe Law::RegulationBase, type: :regulation do
  include_context "with an example regulation"

  it { is_expected.to inherit_from Spicerack::InputModel }

  it { is_expected.to include_module Law::Regulations::Laws }
  it { is_expected.to include_module Law::Regulations::Core }
end
