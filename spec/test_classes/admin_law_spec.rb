# frozen_string_literal: true

RSpec.describe AdminLaw, type: :law do
  it { is_expected.to inherit_from ApplicationLaw }

  it { is_expected.to have_default_statute AdminStatute }
  it { is_expected.to define_action :index, with_statute: AdminStatute }
  it { is_expected.to define_action :show, with_statute: AdminStatute }
end
