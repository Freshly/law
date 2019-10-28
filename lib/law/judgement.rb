# frozen_string_literal: true

# A **Judgement** determines if an **Actor** (represented by their **Roles**) are in violation of the given **Statute**.
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

    attr_reader :petition, :violations, :applied_regulations

    delegate :statute, :applicable_regulations, to: :petition

    def initialize(petition)
      @petition = petition
      @violations = []
      @applied_regulations = []
    end

    def authorized?
      violations.blank?
    end

    def judge
      judge!
    rescue NotAuthorizedError => exception
      error :not_authorized, exception: exception
      false
    end

    def judge!
      return true if statute.unregulated?

      raise InjunctionError if applicable_regulations.blank?
      raise AlreadyJudgedError if applied_regulations.present?

      @applied_regulations = applicable_regulations.map { |regulation| regulation.new(petition: petition) }
      @violations = applied_regulations.reject(&:valid?)

      authorized?
    end
  end
end
