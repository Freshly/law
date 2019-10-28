# frozen_string_literal: true

# Restriction around the terms and conditions of discount creation.
class CreateDiscountStatute < CommonStatute
  impose DiscountAdministratorRegulation, DiscountManagerRegulation
end
