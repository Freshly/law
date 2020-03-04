# frozen_string_literal: true

# A **Law** enforces various **Statutes** to restrict **Actions**.
module Law
  module Laws
    module Actions
      extend ActiveSupport::Concern

      included do
        class_attribute :actions, instance_writer: false, default: HashWithIndifferentAccess.new
        class_attribute :revoked_actions, instance_writer: false, default: HashWithIndifferentAccess.new

        delegate :statute_for_action?, :revoked_action?, to: :class
      end

      class_methods do
        def inherited(base)
          base.actions = actions.dup
          base.revoked_actions = revoked_actions.dup
          super
        end

        def revoked_action?(action)
          revoked_actions[action].present?
        end

        def statute_for_action?(action)
          actions[action].present?
        end

        private

        def revoke_action(*input_actions)
          input_actions.each { |action| revoked_actions[action] = true }
        end

        def define_action(*input_actions, enforces: nil)
          raise ArgumentError, "invalid statute: #{enforces}" unless enforceable?(enforces)

          input_actions.each do |action|
            actions[action] = enforces
            enforces.try(:enforced_by, self, action)
            define_judgement_predicates_for_action(action)
          end
        end

        def enforceable?(enforces)
          enforces.nil? || enforces.respond_to?(:enforced_by)
        end
      end
    end
  end
end
