# frozen_string_literal: true

require_relative "regulations/statutes"
require_relative "regulations/core"

# A **Regulation** is the "lock" which has a matching **Permission** "key".
module Law
  class RegulationBase < Spicerack::InputModel
    include Regulations::Statutes
    include Regulations::Core

    def self.key
      name.chomp("Regulation").underscore.to_sym
    end
  end
end
