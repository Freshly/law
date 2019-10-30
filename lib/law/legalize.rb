# frozen_string_literal: true

# To make something permissible by the enforcement of **Laws**.
module Law
  module Legalize
    extend ActiveSupport::Concern

    included do
      helper_method :policy if respond_to?(:helper_method)
    end

    attr_reader :law, :judgement

    def authorized?
      judgement.try(:authorized?) || false
    end

    def adjudicated?
      judgement.try(:adjudicated?) || false
    end

    def violations
      judgement.try(:violations) || []
    end

    def policy(object)
      nil
    end

    def authorize!(**options)
      authorize(**options) or raise Law::NotAuthorizedError
    end

    def authorize(object: nil, law_class: nil, action: nil, petitioner: nil, permissions: nil, params: nil)
      object ||= try(:controller_name)&.singularize&.camelize&.safe_constantize
      law_class ||= law_finder.class_for(object)
      action ||= try(:action_name)
      petitioner ||= try(:current_user)
      permissions ||= petitioner.try(:permissions)
      params ||= try(:params)

      legal?(law_class, action, permissions, petitioner, object, params)
    end

    def legal?(law_class, action, permissions, source, target, params)
      raise ArgumentError, "a Law is required" unless law_class.is_a?(Class)
      raise ArgumentError, "an action is required" if action.nil?

      @law = law_class.new(permissions: permissions, source: source, target: target, params: params)
      @judgement = @law.authorize(action)
      authorized?
    end

    private

    def law_finder
      @law_finder ||= Spicerack::ClassFinder.new("Law")
    end
  end
end
