# frozen_string_literal: true

RSpec.shared_examples_for "a describable object" do
  describe ".description" do
    subject { example_class.description }

    it { is_expected.to eq description }
  end

  describe ".key" do
    subject { example_class.key }

    let(:root_name) { name_bits.map(&:capitalize).join }
    let(:name_bits) do
      Array.new(3) { Faker::Internet.unique.domain_word }
    end

    it { is_expected.to eq name_bits.join("_").to_sym }
  end
end
