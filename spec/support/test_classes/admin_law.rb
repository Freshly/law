# frozen_string_literal: true

# Restricts sensitive actions intended only for Administrators.
class AdminLaw < CommonLaw
  impose AdministrativeRegulation
end
