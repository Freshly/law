# frozen_string_literal: true

# General System Administrator
class AdminRole < Law::RoleBase
  grant AdministrativePermission, AuthenticationPermission
end
