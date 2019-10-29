# frozen_string_literal: true

# A **Statute** is enforced by **Laws**.
module Law
  module Statutes
    module Laws
      extend ActiveSupport::Concern

      included do
        class_attribute :laws, instance_writer: false, default: Hash.new { |hash, key| hash[key] = [] }
      end

      class_methods do
        def inherited(base)
          base.laws = Hash.new { |hash, key| hash[key] = [] }
          super
        end

        def enforced_by(law, action)
          laws[law] << action
        end
      end
    end
  end
end
