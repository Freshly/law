# frozen_string_literal: true

RSpec.describe Law::Judgement, type: :integration do
  subject { described_class.judge(law: law, roles: roles) }

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
end
