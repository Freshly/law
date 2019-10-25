# frozen_string_literal: true

class CreateDiscountLaw < CommonLaw
  desc "Restriction around the terms and conditions of discount creation."

  impose DiscountAdministratorRegulation, DiscountManagerRegulation
end
