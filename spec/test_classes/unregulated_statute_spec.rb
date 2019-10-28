# frozen_string_literal: true

RSpec.describe UnregulatedStatute, type: :statute do
  it { is_expected.to inherit_from Law::StatuteBase }

  it { is_expected.to be_unregulated }
end
