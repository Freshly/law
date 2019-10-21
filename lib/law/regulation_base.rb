# frozen_string_literal: true

require_relative "regulations/laws"

# A **Regulation** is the "lock" which has a **Permission** "key".
module Law
  class RegulationBase < DescribableObject
    include Regulations::Laws

    type_name "Regulation"
  end
end
