# frozen_string_literal: true

RSpec.describe MarketingManagerRole, type: :role do
  it { is_expected.to inherit_from AdminRole }
  it { is_expected.to have_description "Marketing Management" }

  it { is_expected.to grant_permissions DiscountManagerPermission }
end
