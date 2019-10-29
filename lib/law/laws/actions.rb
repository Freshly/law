# frozen_string_literal: true

# A **Law** enforces various **Statutes** to restrict **Actions**.
module Law
  module Laws
    module Actions
      extend ActiveSupport::Concern

      included do
        class_attribute :actions, instance_writer: false, default: {}

        delegate :statute_for_action?, to: :class
      end

      class_methods do
        def inherited(base)
          base.actions = actions.dup
          super
        end

        def statute_for_action?(action)
          actions[action].present?
        end

        private

        def define_action(action, enforces: nil)
          raise ArgumentError, "invalid statute: #{enforces}" unless enforceable?(enforces)

          actions[action] = enforces
          enforces.try(:enforced_by, self, action)
          define_judgement_predicates_for_action(action)
        end

        def enforceable?(enforces)
          enforces.nil? || enforces.respond_to?(:enforced_by)
        end
      end
    end
  end
end
