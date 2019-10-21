# frozen_string_literal: true

# An abstraction that DRYs out the lock and key system of regulations and permissions.
module Law
  class DescribableObject < Spicerack::RootObject
    include Tablesalt::DSLAccessor

    dsl_accessor :desc

    class << self
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
