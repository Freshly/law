# frozen_string_literal: true

RSpec.describe DoAnythingPermission, type: :permission do
  it { is_expected.to inherit_from Law::PermissionBase }
  it { is_expected.to have_description "Allows unrestricted access to all actions in the system. Use with care!" }

  it { is_expected.to be_granted_to SuperAdminRole }
end
