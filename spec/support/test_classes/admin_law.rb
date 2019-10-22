# frozen_string_literal: true

class AdminLaw < CommonLaw
  desc "Restricts sensitive actions intended only for Administrators."

  impose AdministrativeRegulation
end
