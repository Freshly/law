# frozen_string_literal: true

RSpec.describe Law::Petition, type: :petition do
  include_context "with an example petition"

  it { is_expected.to inherit_from Spicerack::InputModel }

  describe "#actor" do
    subject(:actor) { example_petition.actor }

    context "with nothing" do
      subject(:example_petition) { described_class.new(law: law) }

      it "raises" do
        expect { actor }.to raise_error ArgumentError, "Missing argument: roles"
      end
    end

    context "with roles" do
      context "when one" do
        let(:roles) { role0 }

        it { is_expected.to be_a_kind_of Law::ActorBase }
        it { is_expected.to have_attributes(permissions: role0.permissions) }
      end

      context "when many" do
        let(:roles) { [ role0, role1 ] }

        it { is_expected.to be_a_kind_of Law::ActorBase }
        it { is_expected.to have_attributes(permissions: [ permission0, permission1, permission2 ]) }
      end
    end
  end

  describe "#applicable_regulations" do
    subject(:actor) { example_petition.applicable_regulations }

    context "with nothing" do
      subject(:example_petition) { described_class.new(law: law) }

      it "raises" do
        expect { actor }.to raise_error ArgumentError, "Missing argument: roles"
      end
    end

    context "with partial overlap" do
      let(:roles) { role1 }

      it { is_expected.to eq [ regulation1 ] }
    end

    context "with full overlap" do
      let(:roles) { role0 }

      it { is_expected.to eq [ regulation0, regulation1 ] }
    end
  end
end
