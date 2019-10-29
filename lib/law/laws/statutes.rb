# frozen_string_literal: true

# A **Law** can have a default **Statute** to apply against **Actions** which do not otherwise specify.
module Law
  module Laws
    module Statutes
      extend ActiveSupport::Concern

      included do
        delegate :_default_statute, :default_statute?, to: :class
      end

      class_methods do
        attr_reader :_default_statute

        def inherited(base)
          base.default_statute(_default_statute) if default_statute?
          super
        end

        def default_statute?
          _default_statute.present?
        end

        protected

        def default_statute(statute)
          raise ArgumentError, "invalid statute: #{enforces}" unless statute.respond_to?(:enforced_by)

          @_default_statute = statute
          statute.enforced_by(self, :__default__)
        end
      end
    end
  end
end
