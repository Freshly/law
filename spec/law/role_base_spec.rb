# frozen_string_literal: true

RSpec.describe Law::RoleBase, type: :role do
  include_context "with an example role"

  it { is_expected.to inherit_from Spicerack::RootObject }
end
