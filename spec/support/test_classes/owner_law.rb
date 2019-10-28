# frozen_string_literal: true

# Restriction which requires an actor which owns the target.
class OwnerLaw < CommonLaw
  impose AdministrativeRegulation, OwnerRegulation
end
