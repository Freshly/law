# frozen_string_literal: true

RSpec.describe DiscountLaw, type: :integration do
  subject(:discount_law) { described_class.new(permissions: permissions, params: params) }

  let(:params) { {} }

  shared_examples_for "an adjudicated law" do
    context "when guest" do
      let(:permissions) { [] }

      it { is_expected.to eq guest? }
    end

    context "when user" do
      let(:permissions) { %i[authentication owner] }

      it { is_expected.to eq user? }
    end

    context "when admin" do
      let(:permissions) { %i[administrative authentication] }

      it { is_expected.to eq admin? }
    end

    context "when marketing manager" do
      let(:permissions) { %i[administrative authentication discount_manager] }

      it { is_expected.to eq marketing_manager? }
    end

    context "when marketing executive" do
      let(:permissions) { %i[administrative authentication discount_administrator] }

      it { is_expected.to eq marketing_executive? }
    end

    context "when super admin" do
      let(:permissions) { %i[do_anything] }

      it { is_expected.to eq super_admin? }
    end
  end

  describe ".preview?" do
    subject { described_class.preview?(permissions: permissions, params: params) }

    it_behaves_like "an adjudicated law" do
      let(:guest?) { false }
      let(:user?) { false }
      let(:admin?) { true }
      let(:marketing_manager?) { true }
      let(:marketing_executive?) { true }
      let(:super_admin?) { true }
    end
  end

  describe "#preview?" do
    subject { discount_law.preview? }

    it_behaves_like "an adjudicated law" do
      let(:guest?) { false }
      let(:user?) { false }
      let(:admin?) { true }
      let(:marketing_manager?) { true }
      let(:marketing_executive?) { true }
      let(:super_admin?) { true }
    end
  end

  shared_examples_for "CreateDiscountRegulation is enforced" do
    let(:params) do
      { discount_cents: discount_cents, maximum_usages: maximum_usages }
    end

    context "with unreasonable terms" do
      let(:discount_cents) { 10_000 }
      let(:maximum_usages) { -1 }

      it_behaves_like "an adjudicated law" do
        let(:guest?) { false }
        let(:user?) { false }
        let(:admin?) { false }
        let(:marketing_manager?) { false }
        let(:marketing_executive?) { true }
        let(:super_admin?) { true }
      end
    end

    context "with reasonable terms" do
      let(:discount_cents) { 1000 }
      let(:maximum_usages) { 2 }

      it_behaves_like "an adjudicated law" do
        let(:guest?) { false }
        let(:user?) { false }
        let(:admin?) { false }
        let(:marketing_manager?) { true }
        let(:marketing_executive?) { true }
        let(:super_admin?) { true }
      end
    end
  end

  describe ".new?" do
    subject { described_class.new?(permissions: permissions, params: params) }

    it_behaves_like "CreateDiscountRegulation is enforced"
  end

  describe ".create?" do
    subject { described_class.create?(permissions: permissions, params: params) }

    it_behaves_like "CreateDiscountRegulation is enforced"
  end

  describe "#new?" do
    subject { discount_law.new? }

    it_behaves_like "CreateDiscountRegulation is enforced"
  end

  describe "#create?" do
    subject { discount_law.create? }

    it_behaves_like "CreateDiscountRegulation is enforced"
  end

  shared_examples_for "a revoked action" do
    it_behaves_like "an adjudicated law" do
      let(:guest?) { false }
      let(:user?) { false }
      let(:admin?) { false }
      let(:marketing_manager?) { false }
      let(:marketing_executive?) { false }
      let(:super_admin?) { false }
    end
  end

  shared_examples_for "AdminRegulation is enforced" do
    it_behaves_like "an adjudicated law" do
      let(:guest?) { false }
      let(:user?) { false }
      let(:admin?) { true }
      let(:marketing_manager?) { true }
      let(:marketing_executive?) { true }
      let(:super_admin?) { true }
    end
  end

  describe ".index?" do
    subject { described_class.index?(permissions: permissions, params: params) }

    it_behaves_like "AdminRegulation is enforced"
  end

  describe ".show?" do
    subject { described_class.show?(permissions: permissions, params: params) }

    it_behaves_like "AdminRegulation is enforced"
  end

  describe ".edit?" do
    subject { described_class.edit?(permissions: permissions, params: params) }

    it_behaves_like "a revoked action"
  end

  describe ".update?" do
    subject { described_class.update?(permissions: permissions, params: params) }

    it_behaves_like "a revoked action"
  end

  describe ".destroy?" do
    subject { described_class.destroy?(permissions: permissions, params: params) }

    it_behaves_like "AdminRegulation is enforced"
  end

  describe "#index?" do
    subject { discount_law.index? }

    it_behaves_like "AdminRegulation is enforced"
  end

  describe "#show?" do
    subject { discount_law.show? }

    it_behaves_like "AdminRegulation is enforced"
  end

  describe "#edit?" do
    subject { discount_law.edit? }

    it_behaves_like "a revoked action"
  end

  describe "#update?" do
    subject { discount_law.update? }

    it_behaves_like "a revoked action"
  end

  describe "#destroy?" do
    subject { discount_law.destroy? }

    it_behaves_like "AdminRegulation is enforced"
  end
end
