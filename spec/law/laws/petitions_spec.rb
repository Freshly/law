# frozen_string_literal: true

RSpec.describe Law::Laws::Petitions, type: :concern do
  include_context "with an example law"

  it { is_expected.to define_option :source }
  it { is_expected.to define_option :permissions, default: [] }
  it { is_expected.to define_option :target }
  it { is_expected.to define_option :params, default: {} }

  describe "#petition_for_action" do
    include_context "with petition data"

    subject(:petition_for) { example_law.petition_for_action(action) }

    let(:action) { Faker::Internet.domain_word.to_sym }
    let(:expected_arguments) do
      { statute: statute, source: source, permissions: permissions, target: target, params: params }
    end

    context "when revoked" do
      before do
        example_law_class.__send__(:define_action, action, enforces: statute)
        example_law_class.__send__(:revoke_action, action)
      end

      it { is_expected.to be_nil }
    end

    context "when defined" do
      before { example_law_class.__send__(:define_action, action, enforces: statute) }

      it { is_expected.to be_a_kind_of Law::Petition }
      it { is_expected.to have_attributes(expected_arguments) }
    end

    context "when undefined" do
      context "with default" do
        before { example_law_class.__send__(:default_statute, statute) }

        it { is_expected.to be_a_kind_of Law::Petition }
        it { is_expected.to have_attributes(expected_arguments) }
      end

      context "without default" do
        it "raises" do
          expect { petition_for }.to raise_error ArgumentError, "Missing argument: statute"
        end
      end
    end
  end
end
