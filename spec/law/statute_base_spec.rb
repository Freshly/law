# frozen_string_literal: true

RSpec.describe Law::StatuteBase, type: :statute do
  include_context "with an example statute"

  it { is_expected.to inherit_from Spicerack::RootObject }

  it { is_expected.to include_module Law::Statutes::Regulations }
  it { is_expected.to include_module Law::Statutes::Laws }
end
