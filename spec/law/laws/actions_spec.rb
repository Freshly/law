# frozen_string_literal: true

RSpec.describe Law::Laws::Actions, type: :concern do
  include_context "with an example law"

  it { is_expected.to delegate_method(:statute_for_action?).to(:class) }
  it { is_expected.to delegate_method(:revoked_action?).to(:class) }

  describe ".revoke_action" do
    subject(:revoke_action) { example_law_class.__send__(:revoke_action, action) }

    let(:action) { Faker::Internet.domain_word.to_sym }

    it "revokes action" do
      expect { revoke_action }.to change { example_law_class.revoked_actions }.to(action => true)
    end
  end

  describe ".revoked_action?" do
    subject { example_law_class.revoked_action?(action) }

    let(:action) { Faker::Internet.domain_word.to_sym }

    before { example_law_class.__send__(:define_action, action, enforces: Class.new(Law::StatuteBase)) }

    context "when not revoked" do
      it { is_expected.to be false }
    end

    context "when revoked" do
      before do
        example_law_class.__send__(:revoke_action, action)
      end

      it { is_expected.to be true }
    end
  end

  describe ".define_action" do
    subject(:define_action) { example_law_class.__send__(:define_action, action, enforces: enforces) }

    let(:action) { Faker::Internet.domain_word.to_sym }
    let(:enforces) { nil }

    shared_examples_for "an action is defined" do
      before { allow(example_law_class).to receive(:define_judgement_predicates_for_action) }

      it "defines action" do
        expect { define_action }.to change { example_law_class.actions }.to(action => enforces)
        expect(enforces).to have_received(:enforced_by).with(example_law_class, action) if enforces.present?
        expect(example_law_class).to have_received(:define_judgement_predicates_for_action).with(action)
      end
    end

    shared_examples_for "an error is raised" do
      it "raises" do
        expect { define_action }.to raise_error ArgumentError
      end
    end

    context "without enforcement" do
      context "when implicit" do
        subject(:define_action) { example_law_class.__send__(:define_action, action) }

        it_behaves_like "an action is defined"
      end

      context "when explicit" do
        let(:enforces) { nil }

        it_behaves_like "an action is defined"
      end
    end

    context "with enforcement" do
      context "when statute" do
        include_context "with an example statute"

        context "with class" do
          let(:enforces) { example_statute_class }

          before { allow(enforces).to receive(:enforced_by) }

          it_behaves_like "an action is defined"
        end

        context "with instance" do
          let(:enforces) { example_statute }

          it_behaves_like "an error is raised"
        end
      end

      context "when invalid" do
        let(:enforces) { Faker::Lorem.sentence }

        it_behaves_like "an error is raised"
      end
    end
  end

  describe ".statute_for_action?" do
    subject { example_law_class.statute_for_action?(action) }

    let(:action) { Faker::Internet.domain_word.to_sym }

    context "when undefined" do
      it { is_expected.to be false }
    end

    context "when defined" do
      before { example_law_class.__send__(:define_action, action, enforces: Class.new(Law::StatuteBase)) }

      it { is_expected.to be true }
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :define_action, :actions do
      let(:root_class) do
        Class.new(Law::LawBase) do
          # This is a test for the values being properly inherited, validations are not required and tested elsewhere.
          def self.enforceable?(*)
            true
          end
        end
      end

      let(:expected_attribute_value) do
        expected_property_value.each_with_object(HashWithIndifferentAccess.new) do |action, hash|
          hash[action] = nil
        end
      end
    end

    it_behaves_like "an inherited property", :revoke_action, :revoked_actions do
      let(:root_class) do
        Class.new(Law::LawBase) do
          # This is a test for the values being properly inherited, validations are not required and tested elsewhere.
          def self.enforceable?(*)
            true
          end
        end
      end

      let(:expected_attribute_value) do
        expected_property_value.each_with_object(HashWithIndifferentAccess.new) do |action, hash|
          hash[action] = true
        end
      end
    end
  end
end
