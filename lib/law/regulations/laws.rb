# frozen_string_literal: true

# A **Regulation ** is enforced by various **Laws** to allow restrict actions.
module Law
  module Regulations
    module Laws
      extend ActiveSupport::Concern

      included do
        class_attribute :laws, instance_writer: false, default: []
      end

      class_methods do
        def inherited(base)
          base.laws = []
          super
        end

        def enforced_by(law)
          laws << law
        end
      end
    end
  end
end
