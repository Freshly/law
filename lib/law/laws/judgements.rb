# frozen_string_literal: true

# A **Law** is used to make a **Judgement** about whether an **Action** is authorized.
module Law
  module Laws
    module Judgements
      extend ActiveSupport::Concern

      class_methods do
        private

        def define_judgement_predicates_for_action(action)
          method_name = "#{action}?".to_sym
          define_method(method_name) { authorized?(action) }
          define_singleton_method(method_name) { |**options| new(**options).public_send(method_name) }
        end
      end

      def judgement(action)
        Law::Judgement.new(petition_for_action(action))
      end

      def authorize(action)
        judgement(action).tap(&:judge)
      end

      def authorized?(action)
        judgement(action).judge
      end
    end
  end
end
