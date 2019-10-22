# frozen_string_literal: true

RSpec.describe Law::Judgement, type: :judgement do
  subject { described_class }

  it { is_expected.to inherit_from Spicerack::RootObject }

  describe ".judge!" do
    it_behaves_like "a class pass method", :judge!
  end

  describe ".judge" do
    it_behaves_like "a class pass method", :judge
  end

  describe "#judge" do
    subject(:judge) { example_judgement.judge }

    let(:example_judgement) { described_class.new(petition) }

    let(:petition) { double }

    context "with StandardError" do
      before { allow(example_judgement).to receive(:judge!).and_raise(StandardError) }

      it "raises" do
        expect { judge }.to raise_error StandardError
      end
    end

    context "with Law::NotAuthorizedError" do
      before do
        allow(example_judgement).to receive(:judge!).and_raise(Law::NotAuthorizedError)
        allow(example_judgement).to receive(:error).and_call_original
      end

      it "is logged" do
        expect(judge).to eq false
        expect(example_judgement).
          to have_received(:error).
          with(:not_authorized, exception: instance_of(Law::NotAuthorizedError))
      end
    end

    context "without error" do
      before { allow(example_judgement).to receive(:judge!).and_return(:example_return) }

      it { is_expected.to eq :example_return }
    end
  end

  describe "#judge!" do
    subject(:judge!) { example_judgement.judge! }

    let(:example_judgement) { described_class.new(petition) }
    let(:petition) { double(applicable_regulations: applicable_regulations, law: law) }
    let(:applicable_regulations) { [] }
    let(:regulation) { double }
    let(:law) { double(unregulated?: unregulated?) }

    context "when unregulated" do
      let(:unregulated?) { true }

      it { is_expected.to eq true }
    end

    context "when regulated" do
      let(:unregulated?) { false }

      context "when nothing permitted" do
        it "raises" do
          expect { judge! }.to raise_error Law::InjunctionError
        end
      end

      context "when anything permitted" do
        let(:applicable_regulations) { [ regulation ] }

        it { is_expected.to eq true }
      end
    end
  end
end
