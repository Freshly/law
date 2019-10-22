# frozen_string_literal: true

RSpec.describe Law::Judge, type: :judge do
  subject { described_class }

  it { is_expected.to inherit_from Spicerack::InputModel }
end
