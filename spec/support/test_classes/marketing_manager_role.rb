# frozen_string_literal: true

class MarketingManagerRole < AdminRole
  desc "Marketing Management"

  grant DiscountManagerPermission
end
