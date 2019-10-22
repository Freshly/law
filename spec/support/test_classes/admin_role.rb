# frozen_string_literal: true

class AdminRole < Law::RoleBase
  desc "General System Administrator"

  grant AdministrativePermission
end
