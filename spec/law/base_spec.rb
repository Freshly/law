# frozen_string_literal: true

RSpec.describe Law::Base, type: :law do
  include_context "with an example law"

  it { is_expected.to inherit_from Spicerack::InputObject }

  it { is_expected.to include_module Law::Laws::Actions }
end
