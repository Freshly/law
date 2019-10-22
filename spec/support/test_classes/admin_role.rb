# frozen_string_literal: true

class AdminRole < UserRole
  desc "General System Administrator"

  grant AdministrativePermission
end
