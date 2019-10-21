# frozen_string_literal: true

require_relative "permissions/roles"

# A **Permission** is the "key" that fits the "lock" of a **Regulation**.
module Law
  class PermissionBase < DescribableObject
    include Permissions::Roles

    type_name "Permission"
  end
end
