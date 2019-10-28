# frozen_string_literal: true

# Restriction which requires an authenticated user.
class AuthenticationStatute < CommonStatute
  impose AuthenticationRegulation
end
