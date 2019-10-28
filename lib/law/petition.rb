# frozen_string_literal: true

# A **Petition** is used to determine if an action would violate a given **Law** using a **Judgement**.
module Law
  class Petition < Spicerack::InputObject
    argument :statute, allow_nil: false
    option :source
    option :roles, default: []
    option :target
    option :params, default: {}

    def actor
      Law::ActorBase.new(roles: Array.wrap(roles).flatten.compact.presence || source.try(:roles))
    end
    memoize :actor

    def applicable_regulations
      statute.regulations.select(&actor.method(:permitted_to?))
    end
    memoize :applicable_regulations
  end
end
