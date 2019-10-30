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

    it { is_expected.to match_array :policy }
  end

  describe "#policy" do
    subject { legalized_object.policy(object) }

    let(:object) { double }

    it { is_expected.to be_nil }
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

  describe "#authorize!" do
    subject(:authorize!) { legalized_object.authorize!(**options) }

    let(:options) { Hash[*Faker::Lorem.words(2 * rand(1..2))].symbolize_keys }

    before { allow(legalized_object).to receive(:authorize).with(**options).and_return(authorized?) }

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

  describe "#authorize" do
    subject(:authorize) { legalized_object.authorize(**options) }

    let(:options) do
      { object: input_object,
        law_class: input_law_class,
        action: input_action,
        petitioner: input_petitioner,
        permissions: input_permissions,
        params: input_params }
    end

    let(:law_class) { nil }
    let(:action) { nil }
    let(:permissions) { nil }
    let(:source) { nil }
    let(:target) { nil }
    let(:params) { nil }

    before do
      allow(legalized_object).
        to receive(:legal?).
        with(law_class, action, permissions, source, target, params).
        and_return(legal?)
    end

    shared_examples_for "a judged petition" do
      context "when illegal" do
        let(:legal?) { false }

        it { is_expected.to eq false }
      end

      context "when legal" do
        let(:legal?) { true }

        it { is_expected.to eq true }
      end
    end

    context "without input" do
      let(:input_object) { nil }
      let(:input_law_class) { nil }
      let(:input_action) { nil }
      let(:input_petitioner) { nil }
      let(:input_permissions) { nil }
      let(:input_params) { nil }

      context "with controller_name" do
        let(:object_name) { Faker::Lorem.words(2).join("_").camelize }
        let(:controller_name) { object_name.underscore.pluralize }

        before do
          stub_const(object_name, target)
          allow(legalized_object).to receive(:controller_name).and_return(controller_name)
        end

        it_behaves_like "a judged petition" do
          let(:target) { Class.new }
        end
      end

      context "with findable law" do
        let(:input_object) { object_class.new }

        let(:object_class) { Class.new }

        let(:object_name) { Faker::Lorem.words(2).join("_").camelize }
        let(:law_name) { "#{object_name}Law" }

        before do
          stub_const(object_name, object_class)
          stub_const(law_name, law_class)
        end

        it_behaves_like "a judged petition" do
          let(:target) { input_object }
          let(:law_class) { Class.new }
        end
      end

      context "with action_name" do
        let(:action_name) { Faker::Lorem.words(2).join("_") }

        before { allow(legalized_object).to receive(:action_name).and_return(action_name) }

        it_behaves_like "a judged petition" do
          let(:action) { action_name }
        end
      end

      context "with current_user" do
        let(:current_user) { double }

        before { allow(legalized_object).to receive(:current_user).and_return(current_user) }

        it_behaves_like "a judged petition" do
          let(:source) { current_user }
        end
      end

      context "with petitioner permissions" do
        let(:input_petitioner) { double(permissions: permissions) }

        it_behaves_like "a judged petition" do
          let(:source) { input_petitioner }
          let(:permissions) { [ Faker::Internet.domain_word.to_sym ] }
        end
      end

      context "with params" do
        let(:object_params) { double }

        before { allow(legalized_object).to receive(:params).and_return(object_params) }

        it_behaves_like "a judged petition" do
          let(:params) { object_params }
        end
      end

      context "with nothing" do
        it_behaves_like "a judged petition"
      end
    end

    context "with input" do
      let(:input_object) { double }
      let(:input_law_class) { double }
      let(:input_action) { double }
      let(:input_petitioner) { double }
      let(:input_permissions) { double }
      let(:input_params) { double }

      let(:law_class) { input_law_class }
      let(:action) { input_action }
      let(:permissions) { input_permissions }
      let(:source) { input_petitioner }
      let(:target) { input_object }
      let(:params) { input_params }

      it_behaves_like "a judged petition"
    end
  end

  describe "#legal?" do
    subject(:legal?) { legalized_object.legal?(law_class, action, permissions, source, target, params) }

    let(:action) { Faker::Internet.domain_word }
    let(:permissions) { double }
    let(:source) { double }
    let(:target) { double }
    let(:params) { double }
    let(:statute) { Class.new(Law::StatuteBase) }
    let(:law_class) do
      Class.new(Law::LawBase).tap { |klass| klass.__send__(:default_statute, statute) }
    end

    context "without law_class" do
      let(:law_class) { nil }

      it "raises" do
        expect { legal? }.to raise_error ArgumentError, "a Law is required"
      end
    end

    context "without action" do
      let(:action) { nil }

      it "raises" do
        expect { legal? }.to raise_error ArgumentError, "an action is required"
      end
    end

    context "with arguments" do
      it "makes a judgement" do
        expect { legal? }.
          to change { legalized_object.law }.from(nil).to(an_instance_of(law_class)).
          and change { legalized_object.judgement }.from(nil).to(an_instance_of(Law::Judgement)).
          and change { legalized_object.adjudicated? }.from(false).to(true).
          and change { legalized_object.authorized? }.from(false).to(true)
      end

      it "has law attributes" do
        legal?
        expect(legalized_object.law).
          to have_attributes(permissions: permissions, source: source, target: target, params: params)
      end
    end
  end
end
