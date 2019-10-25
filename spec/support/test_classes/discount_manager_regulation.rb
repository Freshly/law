# frozen_string_literal: true

class DiscountManagerRegulation < Law::RegulationBase
  desc "Restriction with limitations on the terms and conditions of discounts."

  # Business requirement: Managers cannot create discounts greater than $20.00. Ask Adam. HE KNOWS WHY.
  validates :params_discount_cents, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2000 }

  # Business requirement: Managers cannot create unlimited discounts. ADAM AGAIN HAS THE ANSWERS!
  validates :params_maximum_usages, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 3 }
end
