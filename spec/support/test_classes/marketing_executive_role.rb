# frozen_string_literal: true

class MarketingExecutiveRole < AdminRole
  desc "Marketing Directors and Above"

  grant DiscountAdministratorPermission
end
