# frozen_string_literal: true

require_relative "permissions/roles"

# A **Permission** is the "key" that fits the "lock" of a **Regulation**.
module Law
  class PermissionBase < Spicerack::RootObject
    include Permissions::Roles

    def self.key
      name.chomp("Permission").underscore.to_sym
    end
  end
end
