# frozen_string_literal: true

RSpec.describe Law::Laws::Statutes, type: :concern do
  include_context "with an example law"

  it { is_expected.to delegate_method(:_default_statute).to(:class) }
  it { is_expected.to delegate_method(:default_statute?).to(:class) }

  describe ".default_statute" do
    subject(:default_statute) { example_law_class.__send__(:default_statute, _default_statute) }

    let(:_default_statute) { Class.new(Law::StatuteBase) }

    it "assigns _default_statute" do
      expect { default_statute }.
        to change { example_law_class._default_statute }.from(nil).to(_default_statute).
        and change { _default_statute.laws }.from({}).to(example_law_class => %i[__default__])
    end
  end

  describe ".default_statute?" do
    subject { example_law_class }

    context "when undefined" do
      it { is_expected.not_to be_default_statute }
    end

    context "when defined" do
      let(:default_statute) { Class.new(Law::StatuteBase) }

      before { example_law_class.__send__(:default_statute, default_statute) }

      it { is_expected.to be_default_statute }
    end
  end

  describe ".inherited" do
    let(:example_child_law) { Class.new(example_law_class) }
    let(:example_grandchild_law) { Class.new(example_child_law) }
    let(:default_statute) { Class.new(Law::StatuteBase) }

    context "when undefined" do
      it "is nil" do
        expect(example_law_class._default_statute).to be_nil
        expect(example_child_law._default_statute).to be_nil
        expect(example_grandchild_law._default_statute).to be_nil
      end
    end

    context "when defined" do
      before { example_law_class.__send__(:default_statute, default_statute) }

      context "when overridden" do
        let(:child_default_statute) { Class.new(Law::StatuteBase) }

        before { example_child_law.__send__(:default_statute, child_default_statute) }

        it "is inherited" do
          expect(example_law_class._default_statute).to eq default_statute
          expect(example_child_law._default_statute).to eq child_default_statute
          expect(example_grandchild_law._default_statute).to eq child_default_statute
        end
      end

      context "when not overridden" do
        it "is inherited" do
          expect(example_law_class._default_statute).to eq default_statute
          expect(example_child_law._default_statute).to eq default_statute
          expect(example_grandchild_law._default_statute).to eq default_statute
        end
      end
    end
  end
end
