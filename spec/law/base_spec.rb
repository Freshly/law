# frozen_string_literal: true

RSpec.describe Law::Base, type: :law do
  include_context "with an example law"

  it { is_expected.to inherit_from Spicerack::RootObject }
end
