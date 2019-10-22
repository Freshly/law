# frozen_string_literal: true

class SuperAdminRole < AdminRole
  desc "Root Access"

  grant DoAnythingPermission
end
