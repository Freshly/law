# frozen_string_literal: true

RSpec.describe CommonStatute, type: :statute do
  it { is_expected.to inherit_from Law::StatuteBase }

  it { is_expected.to impose_regulations DoAnythingRegulation }
end
