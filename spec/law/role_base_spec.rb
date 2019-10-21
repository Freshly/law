# frozen_string_literal: true

RSpec.describe Law::RoleBase, type: :role do
  subject { described_class }

  it { is_expected.to inherit_from Spicerack::RootObject }
end
