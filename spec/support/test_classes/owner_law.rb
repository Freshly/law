# frozen_string_literal: true

class OwnerLaw < CommonLaw
  desc "Restriction which requires an actor which owns the target."

  impose AdministrativeRegulation, OwnerRegulation
end
