# frozen_string_literal: true

# A **Regulation** is imposed by various **Statutes** to restrict **Actors** from perform actions.
module Law
  module Regulations
    module Statutes
      extend ActiveSupport::Concern

      included do
        class_attribute :statutes, instance_writer: false, default: []
      end

      class_methods do
        def inherited(base)
          base.statutes = []
          super
        end

        def imposed_by(statute)
          statutes << statute
        end
      end
    end
  end
end
