# frozen_string_literal: true

RSpec.describe Law::Judgement, type: :judgement do
  subject(:example_judgement) { described_class.new(petition) }

  let(:petition) { instance_double(Law::Petition, statute: statute) }
  let(:statute) { instance_double(Law::StatuteBase, unregulated?: unregulated?) }
  let(:unregulated?) { true }

  it { is_expected.to inherit_from Spicerack::RootObject }

  it { is_expected.to delegate_method(:statute).to(:petition) }
  it { is_expected.to delegate_method(:applicable_regulations).to(:petition) }

  describe "#authorized?" do
    subject { example_judgement }

    context "without applied_regulations" do
      it { is_expected.not_to be_authorized }
    end

    context "with applied_regulations" do
      before do
        allow(example_judgement).to receive(:applied_regulations).and_return([instance_double(Law::RegulationBase)])
      end

      context "without violations" do
        it { is_expected.to be_authorized }
      end

      context "with violations" do
        before { allow(example_judgement).to receive(:violations).and_return([ instance_double(Law::RegulationBase) ]) }

        it { is_expected.not_to be_authorized }
      end
    end
  end

  describe "#adjudicated?" do
    subject { example_judgement }

    context "without applied_regulations" do
      it { is_expected.not_to be_adjudicated }
    end

    context "with applied_regulations" do
      before do
        allow(example_judgement).to receive(:applied_regulations).and_return([instance_double(Law::RegulationBase)])
      end

      it { is_expected.to be_adjudicated }
    end
  end

  describe ".judge!" do
    it_behaves_like "a class pass method", :judge!
  end

  describe ".judge" do
    it_behaves_like "a class pass method", :judge
  end

  describe "#judge" do
    subject(:judge) { example_judgement.judge }

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

    context "with a petition" do
      before { allow(petition).to receive(:applicable_regulations).and_return(applicable_regulations) }

      let(:applicable_regulations) { [] }

      context "when unregulated" do
        let(:unregulated?) { true }

        it { is_expected.to eq true }
      end

      context "when regulated" do
        let(:unregulated?) { false }

        context "without applicable regulations" do
          it "raises" do
            expect { judge! }.to raise_error Law::InjunctionError
          end
        end

        context "with applicable regulations" do
          let(:applicable_regulations) { [ regulation0_class, regulation1_class ] }

          let(:regulation0_class) { Class.new(Law::RegulationBase) }
          let(:regulation0_instance) { instance_double(regulation0_class, valid?: regulation0_valid?) }

          let(:regulation1_class) { Class.new(Law::RegulationBase) }
          let(:regulation1_instance) { instance_double(regulation1_class, valid?: regulation1_valid?) }

          let(:expected_applied_regulations) { [ regulation0_instance, regulation1_instance ] }
          let(:expected_violations) { [] }

          before do
            allow(regulation0_class).to receive(:new).with(petition: petition).and_return(regulation0_instance)
            allow(regulation1_class).to receive(:new).with(petition: petition).and_return(regulation1_instance)
          end

          shared_examples_for "regulations are applied" do
            it "changes applied_regulations" do
              expect { judge! }.
              to change { example_judgement.applied_regulations }.from([]).to(expected_applied_regulations)
            end
          end

          shared_examples_for "violations are tracked" do
            it "has violations" do
              expect { judge! }.
              to change { example_judgement.applied_regulations }.from([]).to(expected_applied_regulations).
              and change { example_judgement.violations }.from([]).to(expected_violations).
              and raise_error Law::NotAuthorizedError
            end
          end

          context "when no regulations are invalid" do
            let(:regulation0_valid?) { true }
            let(:regulation1_valid?) { true }

            it { is_expected.to eq true }

            it_behaves_like "regulations are applied"
          end

          context "when one regulations are invalid" do
            let(:regulation0_valid?) { true }
            let(:regulation1_valid?) { false }
            let(:expected_violations) { [ regulation1_instance ] }

            it_behaves_like "violations are tracked"
          end

          context "when many regulations are invalid" do
            let(:regulation0_valid?) { false }
            let(:regulation1_valid?) { false }
            let(:expected_violations) { [ regulation0_instance, regulation1_instance ] }

            it_behaves_like "violations are tracked"
          end
        end
      end
    end

    context "without a petition" do
      let(:petition) { nil }

      it "raises" do
        expect { judge! }.to raise_error Law::InjunctionError
      end
    end
  end
end
