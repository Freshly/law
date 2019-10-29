# frozen_string_literal: true

require_relative "laws/actions"
require_relative "laws/statutes"

# A **Law** defines which **Statutes** are enforced against specifics **Actions**.
module Law
  class LawBase < Spicerack::InputObject
    include Law::Laws::Actions
    include Law::Laws::Statutes
  end
end
