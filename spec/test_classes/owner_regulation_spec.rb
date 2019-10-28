# frozen_string_literal: true

RSpec.describe OwnerRegulation, type: :regulation do
  subject { described_class }

  it { is_expected.to inherit_from Law::RegulationBase }
  it { is_expected.to have_description "Restriction requiring the current actor to own the object being modified." }

  it { is_expected.to be_imposed_by OwnerLaw }

  describe "#must_own_target" do
    include_context "with an example petition"

    subject { regulation.errors.details }

    before { regulation.valid? }

    let(:regulation) { described_class.new(petition: example_petition) }
    let(:source) { double(id: source_id) } # rubocop:disable RSpec/VerifiedDoubles
    let(:target) { double(user_id: target_user_id) } # rubocop:disable RSpec/VerifiedDoubles
    let(:source_id) { 1 }

    context "when owner" do
      let(:target_user_id) { source_id }

      it { is_expected.to be_empty }
    end

    context "when not owner" do
      let(:target_user_id) { source_id + 1 }

      it { is_expected.to eq(target: [ error: :does_not_own ]) }
    end
  end
end
