# frozen_string_literal: true

RSpec.describe UserRole, type: :role do
  it { is_expected.to inherit_from Law::RoleBase }
  it { is_expected.to have_description "Signed In User Access" }

  it { is_expected.to grant_permissions AuthenticationPermission, OwnerPermission }
end
