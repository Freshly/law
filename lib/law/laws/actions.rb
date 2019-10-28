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
          raise ArgumentError, "can only enforce Statute classes" unless valid_enforces?(enforces)

          actions[action] = enforces
        end

        def valid_enforces?(enforces)
          return true if enforces.nil?

          enforces.is_a?(Class) && enforces.ancestors.include?(Law::StatuteBase)
        end
      end
    end
  end
end
