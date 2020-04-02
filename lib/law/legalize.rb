# frozen_string_literal: true

# To make something permissible by the enforcement of **Laws**.
module Law
  module Legalize
    extend ActiveSupport::Concern

    included do
      attr_reader :judgement
      helper_method :law if respond_to?(:helper_method)
    end

    def authorized?
      judgement.try(:authorized?) || false
    end

    def adjudicated?
      judgement.try(:adjudicated?) || false
    end

    def violations
      judgement.try(:violations) || []
    end

    def law(object = nil, petitioner = nil, permissions: nil, parameters: nil, law_class: nil)
      object ||= @record || try(:controller_name)&.singularize&.camelize&.safe_constantize
      petitioner ||= try(:current_user)
      permissions ||= petitioner.try(:permissions)
      law_class ||= object.try(:conjugate, Law::LawBase)

      raise ArgumentError, "a Law is required" unless law_class.is_a?(Class)

      law_class.new(permissions: permissions, source: petitioner, target: object, params: parameters)
    end

    def authorize!(action = nil, **options)
      authorize(action, **options) or raise Law::NotAuthorizedError
    end

    def authorize(action = nil, object: nil, petitioner: nil, permissions: nil, parameters: nil, law_class: nil)
      action ||= try(:action_name)
      parameters ||= try(:params)

      raise ArgumentError, "an action is required" if action.nil?

      options = { permissions: permissions, parameters: parameters, law_class: law_class }
      @judgement = law(object, petitioner, **options).authorize(action)
      authorized?
    end
  end
end
