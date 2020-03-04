# frozen_string_literal: true

RSpec.describe DiscountLaw, type: :law do
  it { is_expected.to inherit_from AdminLaw }

  it { is_expected.to have_default_statute AdminStatute }
  it { is_expected.to define_action :new, with_statute: CreateDiscountStatute }
  it { is_expected.to define_action :create, with_statute: CreateDiscountStatute }
  it { is_expected.to revoke_action :edit, :update }
end
