# frozen_string_literal: true

# A **Judgement** determines if an **Actor** (representing a set of **Roles**) are in violation of the given **Law**.
module Law
  class Judgement < Spicerack::RootObject
    class << self
      def judge!(petition)
        new(petition).judge!
      end

      def judge(petition)
        new(petition).judge
      end
    end

    attr_reader :petition

    delegate :law, :applicable_regulations, to: :petition

    def initialize(petition)
      @petition = petition
    end

    def judge
      judge!
    rescue NotAuthorizedError => exception
      error :not_authorized, exception: exception
      false
    end

    def judge!
      return true if law.unregulated?

      raise InjunctionError unless applicable_regulations.present?

      # TODO loop over applicable regulations, which should be InputModels that can run validations.

      true
    end
  end
end
