# frozen_string_literal: true

# Restriction which requires an authenticated user.
class AuthenticationLaw < CommonLaw
  impose AuthenticationRegulation
end
