# frozen_string_literal: true

RSpec.describe AdminRole, type: :role do
  it { is_expected.to inherit_from UserRole }
  it { is_expected.to have_description "General System Administrator" }

  it { is_expected.to grant_permissions AuthenticationPermission, AdministrativePermission }
end
