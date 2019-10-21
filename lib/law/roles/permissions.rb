# frozen_string_literal: true

# A **Role** is authorized to take actions by virtue of having the appropriate **Permissions**.
module Law
  module Roles
    module Permissions
      extend ActiveSupport::Concern

      included do
        class_attribute :permissions, instance_writer: false, default: []
      end

      class_methods do
        def inherited(base)
          base.permissions = permissions.dup
          super
        end

        private

        def grant(*permission_grants)
          permission_grants = permission_grants.flatten.compact

          ensure_valid_permissions(permission_grants)

          permission_grants.each do |permission|
            permissions << permission
            track_permission(permission)
          end
        end

        def track_permission(permission)
          permission.granted_to(self)
        end

        def ensure_valid_permissions(permissions)
          raise ArgumentError, "a permission is required" if permissions.empty?
          invalid_permissions = permissions.reject { |permission| permission.respond_to?(:granted_to) }
          raise ArgumentError, "invalid permissions: #{invalid_permissions.join(", ")}" if invalid_permissions.present?
        end
      end
    end
  end
end
