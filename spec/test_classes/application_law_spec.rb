# frozen_string_literal: true

RSpec.describe ApplicationLaw, type: :law do
  it { is_expected.to inherit_from Law::LawBase }

  it { is_expected.to have_default_statute UnregulatedStatute }
  it { is_expected.to define_action :preview, with_statute: :default }
  it { is_expected.to define_action :index, with_statute: AuthenticationStatute }
  it { is_expected.to define_action :show, with_statute: AuthenticationStatute }
  it { is_expected.to define_action :new, with_statute: AdminStatute }
  it { is_expected.to define_action :create, with_statute: AdminStatute }
  it { is_expected.to define_action :edit, with_statute: AdminStatute }
  it { is_expected.to define_action :update, with_statute: AdminStatute }
  it { is_expected.to define_action :destroy, with_statute: AdminStatute }
end
