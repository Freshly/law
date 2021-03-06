# frozen_string_literal: true

# A **Statute** is a collection of imposed **Regulations**.
module Law
  module Statutes
    module Regulations
      extend ActiveSupport::Concern

      included do
        class_attribute :regulations, instance_writer: false, default: []
        delegate :unregulated?, to: :class
      end

      class_methods do
        def unregulated?
          regulations.empty?
        end

        def inherited(base)
          base.regulations = regulations.dup
          super
        end

        private

        def impose(*imposed_regulations)
          imposed_regulations = imposed_regulations.flatten.compact

          ensure_valid_regulations(imposed_regulations)

          imposed_regulations.each do |regulation|
            regulations << regulation
            track_regulation(regulation)
          end
        end

        def track_regulation(regulation)
          regulation.imposed_by(self)
        end

        def ensure_valid_regulations(imposed_regulations)
          raise ArgumentError, "a regulation is required" if imposed_regulations.empty?

          invalid_regulations = imposed_regulations.reject { |permission| permission.respond_to?(:imposed_by) }
          raise ArgumentError, "invalid regulations: #{invalid_regulations.join(", ")}" if invalid_regulations.present?
        end
      end
    end
  end
end
