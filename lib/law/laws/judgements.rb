# frozen_string_literal: true

# A **Law** is used to make a **Judgement** about whether an **Action** is authorized.
module Law
  module Laws
    module Judgements
      extend ActiveSupport::Concern

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
