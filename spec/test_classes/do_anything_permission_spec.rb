# frozen_string_literal: true

RSpec.describe DoAnythingPermission, type: :permission do
  it { is_expected.to inherit_from Law::PermissionBase }

  it { is_expected.to be_granted_to SuperAdminRole }
end
