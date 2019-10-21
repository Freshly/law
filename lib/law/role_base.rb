# frozen_string_literal: true

require_relative "roles/permissions"

# A **Role** is a collection of **Permissions**.
module Law
  class RoleBase < Spicerack::RootObject
    include Law::Roles::Permissions
  end
end
