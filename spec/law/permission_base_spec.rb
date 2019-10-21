# frozen_string_literal: true

RSpec.describe Law::PermissionBase, type: :permission do
  include_context "with an example permission"

  it { is_expected.to inherit_from Spicerack::RootObject }

  it { is_expected.to include_module Tablesalt::DSLAccessor }

  it { is_expected.to delegate_method(:key).to(:class) }
  it { is_expected.to delegate_method(:description).to(:class) }

  describe ".description" do
    subject { example_permission_class.description }

    it { is_expected.to eq description }
  end

  describe ".key" do
    subject { example_permission_class.key }

    let(:root_name) { name_bits.map(&:capitalize).join }
    let(:name_bits) do
      Array.new(3) { Faker::Internet.unique.domain_word }
    end

    it { is_expected.to eq name_bits.join("_").to_sym }
  end
end
