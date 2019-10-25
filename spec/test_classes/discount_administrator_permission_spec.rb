# frozen_string_literal: true

RSpec.describe DiscountAdministratorPermission, type: :permission do
  it { is_expected.to inherit_from Law::PermissionBase }
  it { is_expected.to have_description "Allows access to create discounts with no limitations." }

  it { is_expected.to be_granted_to MarketingExecutiveRole }
end
