# frozen_string_literal: true

RSpec.describe Law::Laws::Judgements, type: :concern do
  include_context "with an example law"
  include_context "with petition data"

  let(:action) { Faker::Internet.domain_word.to_sym }
  let(:petition) { instance_double(Law::Petition, statute: statute) }

  before { allow(example_law).to receive(:petition_for_action).with(action).and_return(petition) }

  describe "#judgement" do
    subject(:judgement) { example_law.judgement(action) }

    it { is_expected.to be_a_kind_of Law::Judgement }
    it { is_expected.to have_attributes(petition: petition) }
    it { is_expected.not_to be_adjudicated }
  end

  describe "#authorize" do
    subject(:authorize) { example_law.authorize(action) }

    it { is_expected.to be_a_kind_of Law::Judgement }
    it { is_expected.to have_attributes(petition: petition) }
    it { is_expected.to be_adjudicated }
  end

  describe "#authorized?" do
    subject(:authorized?) { example_law.authorized?(action) }

    let(:judgement) { instance_double(Law::Judgement, judge: :judgement_result) }

    before { allow(example_law).to receive(:judgement).with(action).and_return(judgement) }

    it { is_expected.to eq :judgement_result }
  end
end
