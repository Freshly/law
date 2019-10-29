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

  describe ".define_judgement_predicates_for_action" do
    subject(:define_judgement_predicates_for_action) do
      example_law_class.__send__(:define_judgement_predicates_for_action, action)
    end

    let(:predicate) { "#{action}?".to_sym }

    it "defines predicates" do
      expect { define_judgement_predicates_for_action }.
        to change { example_law_class.respond_to?(predicate) }.from(false).to(true).
        and change { example_law_class.method_defined?(predicate) }.from(false).to(true)
    end

    context "when example_action" do
      let(:action) { :example_action }

      describe ".example_action?" do
        before { define_judgement_predicates_for_action }

        it_behaves_like "a class pass method", :example_action? do
          let(:test_class) { example_law_class }
          let(:options) { Hash[:permissions, permissions] }
          let(:permissions) { [ Faker::Internet.domain_word.to_sym ] }
        end
      end

      describe "#example_action?" do
        subject { example_law }

        before do
          define_judgement_predicates_for_action
          allow(example_law).to receive(:authorized?).and_return(authorized?)
        end

        context "when authorized" do
          let(:authorized?) { true }

          it { is_expected.to be_example_action }
        end

        context "when unauthorized" do
          let(:authorized?) { false }

          it { is_expected.not_to be_example_action }
        end
      end
    end
  end
end
