# frozen_string_literal: true

require_relative "laws/actions"

# A **Law** defines which **Statutes** are enforced against specifics **Actions**.
module Law
  class Base < Spicerack::InputObject
    include Law::Laws::Actions
  end
end
