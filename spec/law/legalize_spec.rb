# frozen_string_literal: true

RSpec.describe Law::Legalize, type: :concern do
  subject(:legalized_object) { legalized_class.new }

  let(:legalized_class) do
    Class.new.tap { |klass| klass.include described_class }
  end

  describe ".helper_method" do
    subject { legalized_class.helped_methods }

    let(:legalized_class) do
      Class.new.tap do |klass|
        klass.define_singleton_method(:helped_methods) { @helped_methods ||= [] }
        klass.define_singleton_method(:helper_method) { |method| helped_methods << method }
        klass.include described_class
      end
    end

    it { is_expected.to match_array :law }
  end

  describe "#authorize!" do
    subject(:authorize!) { legalized_object.authorize!(action, **options) }

    let(:action) { Faker::Internet.domain_word }
    let(:options) { Hash[*Faker::Lorem.words(number: 2 * rand(1..2))].symbolize_keys }

    before { allow(legalized_object).to receive(:authorize).with(action, **options).and_return(authorized?) }

    context "when unauthorized" do
      let(:authorized?) { false }

      it "raises" do
        expect { authorize! }.to raise_error Law::NotAuthorizedError
      end
    end

    context "when authorized" do
      let(:authorized?) { true }

      it { is_expected.to eq true }
    end
  end

  describe "#authorized?" do
    context "without adjudication" do
      it { is_expected.not_to be_authorized }
    end

    context "with adjudication" do
      subject { legalized_object }

      let(:judgement) { instance_double(Law::Judgement, authorized?: authorized?) }

      before { allow(legalized_object).to receive(:judgement).and_return(judgement) }

      context "when authorized?" do
        let(:authorized?) { true }

        it { is_expected.to be_authorized }
      end

      context "when not authorized?" do
        let(:authorized?) { false }

        it { is_expected.not_to be_authorized }
      end
    end
  end

  describe "#adjudicated?" do
    subject { legalized_object }

    context "without adjudication" do
      it { is_expected.not_to be_adjudicated }
    end

    context "with adjudication" do
      let(:judgement) { instance_double(Law::Judgement, adjudicated?: adjudicated?) }

      before { allow(legalized_object).to receive(:judgement).and_return(judgement) }

      context "when authorized?" do
        let(:adjudicated?) { true }

        it { is_expected.to be_adjudicated }
      end

      context "when not authorized?" do
        let(:adjudicated?) { false }

        it { is_expected.not_to be_adjudicated }
      end
    end
  end

  describe "#violations" do
    subject { legalized_object.violations }

    context "without adjudication" do
      it { is_expected.to be_empty }
    end

    context "with adjudication" do
      let(:judgement) { instance_double(Law::Judgement, violations: violations) }

      before { allow(legalized_object).to receive(:judgement).and_return(judgement) }

      context "with violations" do
        let(:violations) { [ instance_double(Class.new(Law::RegulationBase)) ] }

        it { is_expected.to eq violations }
      end

      context "without violations" do
        let(:violations) { [] }

        it { is_expected.to be_empty }
      end
    end
  end

  describe "#law" do
    subject(:law) { legalized_object.law(object, petitioner, **options) }

    let(:object) { nil }
    let(:petitioner) { nil }
    let(:input_permissions) { nil }
    let(:input_params) { nil }
    let(:input_law_class) { nil }
    let(:options) do
      { permissions: input_permissions, parameters: input_params, law_class: input_law_class }
    end

    shared_examples_for "no law provided" do
      it "raises" do
        expect { law }.to raise_error ArgumentError, "a Law is required"
      end
    end

    shared_examples_for "a law" do
      let(:law_class) { Class.new(Law::LawBase) }
      let(:permissions) { [] }
      let(:source) { nil }
      let(:target) { nil }
      let(:params) { {} }

      it { is_expected.to be_an_instance_of law_class }
      it { is_expected.to have_attributes(permissions: permissions, source: source, target: target, params: params) }
    end

    shared_context "with example model" do
      let(:example_model_name) { "FooBar" }
      let(:example_model_class) do
        Class.new.tap { |klass| klass.include Conjunction::Conjunctive }
      end

      before { stub_const(example_model_name, example_model_class) }
    end

    shared_context "with example model and law" do
      include_context "with example model"

      let(:example_law_name) { "#{example_model_name}Law" }
      let(:example_law_class) { Class.new(Law::LawBase) }

      before { stub_const(example_law_name, example_law_class) }
    end

    context "with no arguments" do
      subject(:law) { legalized_object.law }

      it_behaves_like "no law provided"
    end

    context "with law_class" do
      let(:input_law_class) { Class.new(Law::LawBase) }

      context "with permissions" do
        let(:input_permissions) do
          Array.new(2) { Faker::Internet.domain_word }.map(&:to_sym)
        end

        it_behaves_like "a law" do
          let(:law_class) { input_law_class }
          let(:permissions) { input_permissions }
        end
      end

      context "without permissions" do
        context "without petitioner" do
          context "without current_user" do
            it_behaves_like "a law" do
              let(:law_class) { input_law_class }
            end
          end

          context "with current_user" do
            before { allow(legalized_object).to receive(:current_user).and_return(current_user) }

            context "without permissions" do
              let(:current_user) { double }

              it_behaves_like "a law" do
                let(:law_class) { input_law_class }
                let(:source) { current_user }
              end
            end

            context "with permissions" do
              let(:current_user) { double(permissions: current_user_permissions) }
              let(:current_user_permissions) do
                Array.new(2) { Faker::Internet.domain_word }.map(&:to_sym)
              end

              it_behaves_like "a law" do
                let(:law_class) { input_law_class }
                let(:source) { current_user }
                let(:permissions) { current_user_permissions }
              end
            end
          end
        end

        context "with petitioner" do
          context "without permissions" do
            let(:petitioner) { double }

            it_behaves_like "a law" do
              let(:law_class) { input_law_class }
              let(:source) { petitioner }
            end
          end

          context "with permissions" do
            let(:petitioner) { double(permissions: petitioner_permissions) }
            let(:petitioner_permissions) do
              Array.new(2) { Faker::Internet.domain_word }.map(&:to_sym)
            end

            it_behaves_like "a law" do
              let(:law_class) { input_law_class }
              let(:source) { petitioner }
              let(:permissions) { petitioner_permissions }
            end
          end
        end
      end
    end

    context "when law_class implied" do
      include_context "with example model and law"

      context "without object" do
        context "without controller_name" do
          it_behaves_like "no law provided"
        end

        context "with controller_name" do
          let(:controller_name) { example_model_class.name.underscore.pluralize }

          before { allow(legalized_object).to receive(:controller_name).and_return(controller_name) }

          it_behaves_like "a law" do
            let(:target) { example_model_class }
            let(:law_class) { example_law_class }
          end
        end
      end

      context "with object" do
        context "when model instance" do
          let(:object) { example_model_class.new }

          it_behaves_like "a law" do
            let(:law_class) { example_law_class }
            let(:target) { object }
          end
        end

        context "when model class" do
          let(:object) { example_model_class }

          it_behaves_like "a law" do
            let(:law_class) { example_law_class }
            let(:target) { object }
          end
        end

        context "when model name" do
          let(:object) { example_model_class.name }

          it_behaves_like "no law provided"
        end

        context "when symbol representing model name" do
          let(:object) { example_model_class.name.underscore.to_sym }

          it_behaves_like "no law provided"
        end
      end
    end
  end

  describe "#authorize" do
    subject(:authorize) { legalized_object.authorize(action, **options) }

    let(:action) { Faker::Internet.domain_word }
    let(:input_object) { double }
    let(:input_petitioner) { double }
    let(:input_permissions) { double }
    let(:input_parameters) { double }
    let(:input_law_class) { double }
    let(:law) { instance_double(Law::LawBase) }
    let(:judgement) { instance_double(Law::Judgement) }
    let(:authorized?) { rand(1..2) % 2 == 0 }
    let(:options) do
      { object: input_object,
        petitioner: input_petitioner,
        permissions: input_permissions,
        parameters: input_parameters,
        law_class: input_law_class }
    end

    before do
      allow(legalized_object).to receive(:law).and_return(law)
      allow(legalized_object).to receive(:authorized?).and_return(authorized?)
      allow(law).to receive(:authorize).with(action).and_return(judgement)
    end

    shared_examples_for "an authorized law" do
      let(:object) { input_object }
      let(:petitioner) { input_petitioner }
      let(:permissions) { input_permissions }
      let(:parameters) { input_parameters }
      let(:law_class) { input_law_class }

      it { is_expected.to eq authorized? }

      it "makes a legal judgement" do
        expect { authorize }.to change { legalized_object.judgement }.from(nil).to(judgement)

        expect(legalized_object).
        to have_received(:law).
        with(object, petitioner, permissions: permissions, parameters: parameters, law_class: law_class)
      end
    end

    context "with action" do
      context "without input parameters" do
        let(:input_parameters) { nil }

        context "without params" do
          it_behaves_like "an authorized law"
        end

        context "with params" do
          let(:params) { Faker::Lorem.words(2).map(&:to_sym) }

          before { allow(legalized_object).to receive(:params).and_return(params) }

          it_behaves_like "an authorized law" do
            let(:parameters) { params }
          end
        end
      end

      context "with input parameters" do
        it_behaves_like "an authorized law"
      end
    end

    context "without action" do
      let(:action) { nil }

      context "without action_name" do
        it "raises" do
          expect { authorize }.to raise_error ArgumentError, "an action is required"
        end
      end

      context "with params" do
        let(:action_name) { Faker::Lorem.words(2).map(&:to_sym) }

        before { allow(legalized_object).to receive(:action_name).and_return(action_name) }

        it_behaves_like "an authorized law" do
          let(:action) { action_name }
        end
      end
    end
  end
end
