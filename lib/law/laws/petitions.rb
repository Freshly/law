# frozen_string_literal: true

# A **Law** creates a **Petition** for the **Statute** enforced against an **Action**; all other data must be specified.
module Law
  module Laws
    module Petitions
      extend ActiveSupport::Concern

      included do
        option :source
        option :permissions, default: []
        option :target
        option :params, default: {}
      end

      def petition_for_action(action)
        return if revoked_action?(action)

        Law::Petition.new(
          statute: actions[action] || _default_statute,
          source: source,
          permissions: permissions,
          target: target,
          params: params,
        )
      end
    end
  end
end
