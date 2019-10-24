# frozen_string_literal: true

# A module that enables setting a class-specific description of itself.
module Law
  module Describable
    extend ActiveSupport::Concern

    included do
      include Tablesalt::DSLAccessor

      dsl_accessor :desc
    end

    class_methods do
      def key
        name.chomp(@type_name).underscore.to_sym
      end

      def description
        desc
      end

      def inherited(base)
        base.type_name @type_name if defined?(@type_name)
      end

      protected

      def type_name(name)
        @type_name = name
      end
    end
  end
end
