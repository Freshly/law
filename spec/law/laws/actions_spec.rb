# frozen_string_literal: true

RSpec.describe Law::Laws::Actions, type: :concern do
  include_context "with an example law"

  it { is_expected.to delegate_method(:statute_for_action?).to(:class) }

  describe ".define_action" do
    subject(:define_action) { example_law_class.__send__(:define_action, action, enforces: enforces) }

    let(:action) { Faker::Internet.domain_word.to_sym }
    let(:enforces) { nil }

    shared_examples_for "an action is defined" do
      it "defines action" do
        expect { define_action }.to change { example_law_class.actions }.from({}).to(action => enforces)
      end
    end

    shared_examples_for "an error is raised" do
      it "raises" do
        expect { define_action }.to raise_error ArgumentError, "can only enforce Statute classes"
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
          def self.valid_enforces?(*)
            true
          end
        end
      end

      let(:expected_attribute_value) do
        expected_property_value.each_with_object({}) do |action, hash|
          hash[action] = nil
        end
      end
    end
  end
end
