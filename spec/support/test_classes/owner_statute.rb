# frozen_string_literal: true

# Restriction which requires an actor which owns the target.
class OwnerStatute < CommonStatute
  impose AdministrativeRegulation, OwnerRegulation
end
