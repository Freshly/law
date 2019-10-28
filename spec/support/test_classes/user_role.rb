# frozen_string_literal: true

# Signed In User Access
class UserRole < Law::RoleBase
  grant AuthenticationPermission, OwnerPermission
end
