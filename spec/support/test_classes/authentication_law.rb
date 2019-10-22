# frozen_string_literal: true

class AuthenticationLaw < CommonLaw
  desc "Restriction which requires an authenticated user."

  impose AuthenticationRegulation
end
