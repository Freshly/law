# frozen_string_literal: true

RSpec.describe AdministrativePermission, type: :permission do
  it { is_expected.to inherit_from Law::PermissionBase }
  it { is_expected.to have_description "Allows access to all general administrative actions in the system." }

  it { is_expected.to be_granted_to AdminRole }
end
