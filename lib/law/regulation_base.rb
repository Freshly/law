# frozen_string_literal: true

require_relative "regulations/laws"

# A **Regulation** is the "lock" which has a matching **Permission** "key".
module Law
  class RegulationBase < Spicerack::InputModel
    include Describable

    include Regulations::Laws

    type_name "Regulation"
  end
end
