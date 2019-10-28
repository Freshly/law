# frozen_string_literal: true

RSpec.describe OwnerStatute, type: :statute do
  it { is_expected.to inherit_from CommonStatute }

  it { is_expected.to impose_regulations DoAnythingRegulation, AdministrativeRegulation, OwnerRegulation }
end
