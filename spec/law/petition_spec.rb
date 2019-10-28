# frozen_string_literal: true

RSpec.describe Law::Petition, type: :petition do
  include_context "with an example petition"

  it { is_expected.to inherit_from Spicerack::InputObject }

  it { is_expected.to define_argument :statute, allow_nil: false }
  it { is_expected.to define_option :source }
  it { is_expected.to define_option :permissions, default: [] }
  it { is_expected.to define_option :target }
  it { is_expected.to define_option :params, default: {} }

  describe "#permission_list" do
    subject(:permission_list) { example_petition.permission_list }

    context "with nothing" do
      let(:example_petition) { described_class.new(statute: statute) }

      it { is_expected.to be_empty }
    end

    context "with permissions" do
      context "when symbols" do
        let(:permissions) { %i[foo bar] }

        it { is_expected.to be_a_kind_of Collectible::CollectionBase }
        it { is_expected.to match_array permissions }
      end

      context "when not" do
        let(:permissions) { %w[foo bar] }

        it "raises" do
          expect { permission_list }.to raise_error Collectible::ItemNotAllowedError, "not allowed: \"foo\", \"bar\""
        end
      end
    end
  end

  describe "#applicable_regulations" do
    subject(:actor) { example_petition.applicable_regulations }

    context "with nothing" do
      let(:example_petition) { described_class.new(statute: statute) }

      it { is_expected.to be_empty }
    end

    context "with partial overlap" do
      let(:permissions) { regulation1.key }

      it { is_expected.to eq [ regulation1 ] }
    end

    context "with full overlap" do
      let(:permissions) { [ regulation0.key, regulation1.key ] }

      it { is_expected.to eq [ regulation0, regulation1 ] }
    end
  end
end
