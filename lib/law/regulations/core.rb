# frozen_string_literal: true

# A **Regulation** accepts a **Petition** and applies **Validations** to ensure the request is acceptable.
module Law
  module Regulations
    module Core
      extend ActiveSupport::Concern

      included do
        argument :petition
      end

      private

      def respond_to_missing?(method_name, include_private = false)
        petition_delegate, delegated_method_name = petition_delegator_for_method_name(method_name)
        delegation_type(petition_delegate, delegated_method_name) != :none || super
      end

      def method_missing(method_name, *arguments)
        petition_delegate, delegated_method_name = petition_delegator_for_method_name(method_name)

        case delegation_type(petition_delegate, delegated_method_name)
        when :method
          petition_delegate.public_send(delegated_method_name, *arguments)
        when :attribute_sym
          petition_delegate[delegated_method_name]
        when :attribute_str
          petition_delegate[delegated_method_name.to_s]
        else
          super
        end
      end

      def delegation_type(petition_delegate, delegated_method_name)
        unless petition_delegate.nil?
          return :method if petition_delegate.respond_to?(delegated_method_name)

          if petition_delegate.respond_to?(:key?)
            return :attribute_sym if petition_delegate.key?(delegated_method_name)
            return :attribute_str if petition_delegate.key?(delegated_method_name.to_s)
          end
        end

        :none
      end

      def petition_delegator_for_method_name(method_name)
        parts = method_name.to_s.split("_")
        petition_delegate = parts.shift.to_sym

        return if petition_delegate.nil? || !petition.respond_to?(petition_delegate)

        [ petition.public_send(petition_delegate), parts.join("_").to_sym ]
      end
    end
  end
end
