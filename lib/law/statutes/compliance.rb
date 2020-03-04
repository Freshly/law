# frozen_string_literal: true

# A **Statute** is a collection of imposed **Regulations** with some **Compliance** rules.
module Law
  module Statutes
    module Compliance
      extend ActiveSupport::Concern

      class_methods do
        def full_compliance_required?
          @require_full_compliance.present?
        end

        def inherited(base)
          base.require_full_compliance if full_compliance_required?
          super
        end

        protected

        def require_full_compliance
          @require_full_compliance = true
        end
      end
    end
  end
end
