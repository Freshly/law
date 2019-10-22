# frozen_string_literal: true

# A **Judgement** determines if an **Actor** (representing a set of **Roles**) are in violation of the given **Law**.
module Law
  class Judgement < Spicerack::InputModel
    argument :actor, allow_nil: false
    argument :law, allow_nil: false

    class << self
      def judge!(law:, **options)
        for_law(law, **options).judge!
      end

      def judge(law:, **options)
        for_law(law, **options).judge
      end

      def for_law(law, actor: nil, roles: nil)
        raise ArgumentError, "provide either actor or roles, not both!" if actor.present? && roles.present?
        new(actor: resolve_actor(actor, roles), law: law)
      end

      private

      def resolve_actor(actor, roles)
        actor ||= Law::ActorBase.new(roles: roles) if roles.present?
        raise ArgumentError, "an actor or roles are required!" unless actor.present?

        actor
      end
    end

    def judge
      judge!
    rescue NotAuthorizedError => exception
      error :not_authorized, exception: exception
      false
    end

    def judge!
      raise InjunctionError unless applicable_regulations.present?

      # TODO loop over applicable regulations, which should be InputModels that can run validations.

      true
    end

    private

    def applicable_regulations
      law.regulations.select(&actor.method(:permitted_to?))
    end
    memoize :applicable_regulations
  end
end
