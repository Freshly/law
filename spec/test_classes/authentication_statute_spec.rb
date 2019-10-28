# frozen_string_literal: true

RSpec.describe AuthenticationStatute, type: :statute do
  it { is_expected.to inherit_from CommonStatute }

  it { is_expected.to impose_regulations DoAnythingRegulation, AuthenticationRegulation }
end
