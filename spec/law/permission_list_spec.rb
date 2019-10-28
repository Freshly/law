# frozen_string_literal: true

RSpec.describe Law::PermissionList, type: :permission_list do
  it { is_expected.to inherit_from Collectible::CollectionBase }

  describe ".item_class" do
    subject { described_class.item_class }

    it { is_expected.to eq Symbol }
  end
end
