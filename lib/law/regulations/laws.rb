# frozen_string_literal: true

# A **Regulation** is imposed by various **Laws** to restrict actions.
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

        def imposed_by(law)
          laws << law
        end
      end
    end
  end
end
