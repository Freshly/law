# frozen_string_literal: true

RSpec.describe AdminStatute, type: :statute do
  it { is_expected.to inherit_from Law::StatuteBase }

  it { is_expected.to impose_regulations DoAnythingRegulation, AdministrativeRegulation }
  it { is_expected.to be_default_for AdminLaw, DiscountLaw }
  it { is_expected.to be_enforced_by ApplicationLaw, %i[new create edit update destroy] }
  it { is_expected.to be_enforced_by AdminLaw, :index, :show }
end
