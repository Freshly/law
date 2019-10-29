# frozen_string_literal: true

# A **Law** can have a default **Statute** to apply against **Actions** which do not otherwise specify.
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
