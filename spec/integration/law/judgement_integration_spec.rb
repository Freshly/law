# frozen_string_literal: true

RSpec.describe Law::Judgement, type: :integration do
  include_context "with an example petition"

  subject(:judge) { described_class.judge(example_petition) }

  shared_examples_for "an enforced law" do
    context "when guest" do
      let(:roles) { GuestRole }

      it { is_expected.to eq guest? }
    end

    context "when user" do
      let(:roles) { UserRole }

      it { is_expected.to eq user? }
    end

    context "when admin" do
      let(:roles) { AdminRole }

      it { is_expected.to eq admin? }
    end

    context "when super admin" do
      let(:roles) { SuperAdminRole }

      it { is_expected.to eq super_admin? }
    end
  end

  context "when unregulated" do
    let(:law) { UnregulatedLaw }

    it_behaves_like "an enforced law" do
      let(:guest?) { true }
      let(:user?) { true }
      let(:admin?) { true }
      let(:super_admin?) { true }
    end
  end

  context "with CommonLaw" do
    let(:law) { CommonLaw }

    it_behaves_like "an enforced law" do
      let(:guest?) { false }
      let(:user?) { false }
      let(:admin?) { false }
      let(:super_admin?) { true }
    end
  end

  context "with AuthenticationLaw" do
    let(:law) { AuthenticationLaw }

    it_behaves_like "an enforced law" do
      let(:guest?) { false }
      let(:user?) { true }
      let(:admin?) { true }
      let(:super_admin?) { true }
    end
  end

  context "with AdminLaw" do
    let(:law) { AdminLaw }

    it_behaves_like "an enforced law" do
      let(:guest?) { false }
      let(:user?) { false }
      let(:admin?) { true }
      let(:super_admin?) { true }
    end
  end

  context "with OwnerLaw" do
    let(:law) { OwnerLaw }
    let(:user_class) do
      Class.new.tap do |klass|
        klass.define_method(:id) { 1 }
      end
    end
    let(:source) { user_class.new }
    let(:target) { target_class.new }

    context "with no target" do
      let(:roles) { UserRole }
      let(:target) { nil }

      it "raises" do
        expect { judge }.to raise_error NameError
      end
    end

    context "with invalid target class" do
      let(:roles) { UserRole }
      let(:target_class) { Class.new }

      it "raises" do
        expect { judge }.to raise_error NameError
      end
    end

    context "when owner" do
      let(:target_class) do
        Class.new.tap do |klass|
          klass.define_method(:user_id) { 1 }
        end
      end

      it_behaves_like "an enforced law" do
        let(:guest?) { false }
        let(:user?) { true }
        let(:admin?) { true }
        let(:super_admin?) { true }
      end
    end

    context "when stranger" do
      let(:target_class) do
        Class.new.tap do |klass|
          klass.define_method(:user_id) { 2 }
        end
      end

      it_behaves_like "an enforced law" do
        let(:guest?) { false }
        let(:user?) { false }
        let(:admin?) { true }
        let(:super_admin?) { true }
      end
    end
  end
end
