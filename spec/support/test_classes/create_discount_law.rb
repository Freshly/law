# frozen_string_literal: true

# Restriction around the terms and conditions of discount creation.
class CreateDiscountLaw < CommonLaw
  impose DiscountAdministratorRegulation, DiscountManagerRegulation
end
