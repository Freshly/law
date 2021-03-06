# frozen_string_literal: true

require_relative "laws/actions"
require_relative "laws/statutes"
require_relative "laws/petitions"
require_relative "laws/judgements"

# A **Law** defines which **Statutes** are enforced against specifics **Actions**.
module Law
  class LawBase < Spicerack::InputObject
    include Conjunction::Junction
    suffixed_with "Law"

    include Law::Laws::Judgements
    include Law::Laws::Actions
    include Law::Laws::Statutes
    include Law::Laws::Petitions
  end
end
