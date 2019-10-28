# frozen_string_literal: true

# Restricts sensitive actions intended only for Administrators.
class AdminStatute < CommonStatute
  impose AdministrativeRegulation
end
