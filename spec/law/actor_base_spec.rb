# frozen_string_literal: true

RSpec.describe Law::ActorBase, type: :actor do
  include_context "with an example actor"

  it { is_expected.to inherit_from Spicerack::InputObject }
end
