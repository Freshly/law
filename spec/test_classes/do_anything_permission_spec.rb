# frozen_string_literal: true

RSpec.describe DoAnythingPermission, type: :permission do
  it { is_expected.to inherit_from Law::PermissionBase }
  it { is_expected.to have_description "Allow execution of any and all actions in the system." }

  it { is_expected.to include_roles SuperAdminRole }
end
