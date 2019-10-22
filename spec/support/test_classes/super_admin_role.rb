# frozen_string_literal: true

class SuperAdminRole < Law::RoleBase
  desc "Root Access"

  grant DoAnythingPermission
end
