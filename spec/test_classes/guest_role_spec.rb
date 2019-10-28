# frozen_string_literal: true

RSpec.describe GuestRole, type: :role do
  it { is_expected.to inherit_from Law::RoleBase }

  it { is_expected.to be_unpermitted }
end
