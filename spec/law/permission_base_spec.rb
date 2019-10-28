# frozen_string_literal: true

RSpec.describe Law::PermissionBase, type: :permission do
  include_context "with an example permission"

  it { is_expected.to inherit_from Spicerack::RootObject }

  it { is_expected.to include_module Law::Permissions::Roles }
end
