# frozen_string_literal: true

class UserRole < Law::RoleBase
  desc "Signed In User Access"

  grant AuthenticationPermission
end
