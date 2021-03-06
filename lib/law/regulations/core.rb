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
        petition_delegate, delegated_method_name, is_setter = petition_delegator_for_method_name(method_name)
        delegation_type(petition_delegate, delegated_method_name, is_setter) != :none || super
      end

      def method_missing(method_name, *arguments)
        petition_delegate, delegated_method_name, is_setter = petition_delegator_for_method_name(method_name)

        case delegation_type(petition_delegate, delegated_method_name, is_setter)
        when :delegate
          petition_delegate
        when :method
          petition_delegate.public_send(delegated_method_name, *arguments)
        when :attribute_set
          petition_delegate[delegated_method_name] = arguments.first
        when :attribute_sym
          petition_delegate[delegated_method_name]
        when :attribute_str
          petition_delegate[delegated_method_name.to_s]
        else
          super
        end
      end

      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/CyclomaticComplexity
      def delegation_type(petition_delegate, delegated_method_name, is_setter)
        unless petition_delegate.nil?
          return :delegate if delegated_method_name.blank? && !is_setter

          method_name_to_test = is_setter ? "#{delegated_method_name}=".to_sym : delegated_method_name
          return :method if petition_delegate.respond_to?(method_name_to_test)

          if petition_delegate.respond_to?(:key?)
            return :attribute_set if is_setter
            return :attribute_sym if petition_delegate.key?(delegated_method_name)
            return :attribute_str if petition_delegate.key?(delegated_method_name.to_s)
          end
        end

        :none
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      def petition_delegator_for_method_name(method_name)
        parts = method_name.to_s.split("_")
        petition_delegate = parts.shift.to_sym

        return if petition_delegate.nil? || !petition.respond_to?(petition_delegate)

        method_name = parts.join("_")
        is_setter = method_name.delete_suffix!("=").present?

        [ petition.public_send(petition_delegate), method_name.to_sym, is_setter ]
      end
    end
  end
end
