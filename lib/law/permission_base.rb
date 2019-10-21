# frozen_string_literal: true

# A **Permission** is the "key" that fits the "lock" of a **Regulation**.
module Law
  class PermissionBase < Spicerack::RootObject
    include Tablesalt::DSLAccessor

    dsl_accessor :desc

    class << self
      def key
        name.chomp("Permission").underscore.to_sym
      end

      def description
        desc
      end
    end

    delegate :key, :description, to: :class
  end
end
