# frozen_string_literal: true

RSpec.describe Law::Judgement, type: :judgement do
  subject { described_class }

  it { is_expected.to inherit_from Spicerack::InputModel }

  describe ".for_law" do
    let(:regulation0) { Class.new(Law::RegulationBase) }
    let(:regulation1) { Class.new(Law::RegulationBase) }

    let(:law) do
      Class.new(Law::LawBase).tap { |klass| klass.__send__(:impose, regulation0, regulation1) }
    end

    context "without actor or roles" do
      subject(:for_law) { described_class.for_law(law) }

      it "raises" do
        expect { for_law }.to raise_error ArgumentError, "an actor or roles are required!"
      end
    end

    context "with both actor and roles" do
      subject(:for_law) { described_class.for_law(law, actor: double, roles: double) }

      it "raises" do
        expect { for_law }.to raise_error ArgumentError, "provide either actor or roles, not both!"
      end
    end

    context "with actor" do
      subject(:for_law) { described_class.for_law(law, actor: actor) }

      let(:actor) { double }
      let(:instance) { double }

      before { allow(described_class).to receive(:new).with(law: law, actor: actor).and_return(instance) }

      it { is_expected.to eq instance }
    end

    context "with roles" do
      subject(:for_law) { described_class.for_law(law, roles: roles) }

      let(:roles) { double }
      let(:actor) { double }
      let(:instance) { double }

      before do
        allow(Law::ActorBase).to receive(:new).with(roles: roles).and_return(actor)
        allow(described_class).to receive(:new).with(law: law, actor: actor).and_return(instance)
      end

      it { is_expected.to eq instance }
    end
  end

  shared_examples_for "a passthru method" do |method_name|
    subject { described_class.public_send(method_name, law: law, roles: roles, actor: actor) }

    let(:law) { double }
    let(:roles) { double }
    let(:actor) { double }
    let(:instance) { double(method_name => :example_return) }

    before { allow(described_class).to receive(:for_law).with(law, roles: roles, actor: actor).and_return(instance) }

    it { is_expected.to eq :example_return }
  end

  describe ".judge!" do
    it_behaves_like "a passthru method", :judge!
  end

  describe ".judge" do
    it_behaves_like "a passthru method", :judge
  end

  describe "#judge" do
    subject(:judge) { example_judgement.judge }

    let(:example_judgement) { described_class.new(law: law, actor: actor) }

    let(:law) { double }
    let(:actor) { double }

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

    let(:example_judgement) { described_class.new(law: law, actor: actor) }
    let(:regulation) { double }
    let(:regulations) { [ regulation ] }
    let(:law) { double(unregulated?: false, regulations: regulations) }

    context "when nothing permitted" do
      let(:actor) { double(permitted_to?: false) }

      it "raises" do
        expect { judge! }.to raise_error Law::InjunctionError
      end
    end

    context "when anything permitted" do
      let(:actor) { double(permitted_to?: true) }

      it { is_expected.to eq true }
    end
  end
end
