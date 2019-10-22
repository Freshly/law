# frozen_string_literal: true

# An **Actor** is a collection of **Roles**.
module Law
  module Actors
    module Permissions
      extend ActiveSupport::Concern

      included do
        argument :roles, allow_nil: false

        memoize :permissions
        memoize :permissions_map
      end

      def permitted_to?(key)
        permissions_map.key?(key) || permissions.include?(key)
      end

      def permissions_map
        permissions.index_by(&:key)
      end

      def permissions
        Array.wrap(roles).map(&:permissions).flatten.uniq
      end
    end
  end
end
