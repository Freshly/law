# frozen_string_literal: true

require_relative "roles/permissions"

# A **Role** is authorized to take actions by virtue of having the appropriate **Permissions**.
module Law
  class RoleBase < DescribableObject
    include Law::Roles::Permissions

    type_name "Role"
  end
end
