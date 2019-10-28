# frozen_string_literal: true

RSpec.describe Law::Judgement, type: :integration do
  include_context "with an example petition"

  subject(:judge) { judgement.judge }

  let(:judgement) { described_class.new(example_petition) }

  shared_examples_for "an enforced statute" do
    context "with GuestRole" do
      let(:roles) { GuestRole }

      it { is_expected.to eq guest? }
    end

    context "with UserRole" do
      let(:roles) { UserRole }

      it { is_expected.to eq user? }
    end

    context "with AdminRole" do
      let(:roles) { AdminRole }

      it { is_expected.to eq admin? }
    end

    context "with MarketingManagerRole" do
      let(:roles) { MarketingManagerRole }

      it { is_expected.to eq marketing_manager? }
    end

    context "with MarketingExecutiveRole" do
      let(:roles) { MarketingExecutiveRole }

      it { is_expected.to eq marketing_executive? }
    end

    context "with SuperAdminRole" do
      let(:roles) { SuperAdminRole }

      it { is_expected.to eq super_admin? }
    end
  end

  context "when UnregulatedStatute" do
    let(:statute) { UnregulatedStatute }

    it_behaves_like "an enforced statute" do
      let(:guest?) { true }
      let(:user?) { true }
      let(:admin?) { true }
      let(:marketing_manager?) { true }
      let(:marketing_executive?) { true }
      let(:super_admin?) { true }
    end
  end

  context "with CommonStatute" do
    let(:statute) { CommonStatute }

    it_behaves_like "an enforced statute" do
      let(:guest?) { false }
      let(:user?) { false }
      let(:admin?) { false }
      let(:marketing_manager?) { false }
      let(:marketing_executive?) { false }
      let(:super_admin?) { true }
    end
  end

  context "with AuthenticationStatute" do
    let(:statute) { AuthenticationStatute }

    it_behaves_like "an enforced statute" do
      let(:guest?) { false }
      let(:user?) { true }
      let(:admin?) { true }
      let(:marketing_manager?) { true }
      let(:marketing_executive?) { true }
      let(:super_admin?) { true }
    end
  end

  context "with AdminStatute" do
    let(:statute) { AdminStatute }

    it_behaves_like "an enforced statute" do
      let(:guest?) { false }
      let(:user?) { false }
      let(:admin?) { true }
      let(:marketing_manager?) { true }
      let(:marketing_executive?) { true }
      let(:super_admin?) { true }
    end
  end

  context "with OwnerStatute" do
    let(:statute) { OwnerStatute }
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

      it_behaves_like "an enforced statute" do
        let(:guest?) { false }
        let(:user?) { true }
        let(:admin?) { true }
        let(:marketing_manager?) { true }
        let(:marketing_executive?) { true }
        let(:super_admin?) { true }
      end
    end

    context "when stranger" do
      let(:target_class) do
        Class.new.tap do |klass|
          klass.define_method(:user_id) { 2 }
        end
      end

      describe "#violations" do
        subject { judgement.violations }

        let(:roles) { UserRole }

        before { judge }

        it { is_expected.to match_array [ instance_of(OwnerRegulation) ] }

        describe "#errors.details" do
          subject { judgement.violations.map(&:errors).map(&:details) }

          let(:target_errors) do
            { target: [ error: :does_not_own ] }
          end

          it { is_expected.to eq([ target_errors ]) }
        end
      end

      it_behaves_like "an enforced statute" do
        let(:guest?) { false }
        let(:user?) { false }
        let(:admin?) { true }
        let(:marketing_manager?) { true }
        let(:marketing_executive?) { true }
        let(:super_admin?) { true }
      end
    end
  end

  context "with CreateDiscountStatute" do
    let(:statute) { CreateDiscountStatute }
    let(:params) do
      { discount_cents: discount_cents, maximum_usages: maximum_usages }
    end

    context "with reasonable terms" do
      let(:discount_cents) { 1000 }
      let(:maximum_usages) { 2 }

      it_behaves_like "an enforced statute" do
        let(:guest?) { false }
        let(:user?) { false }
        let(:admin?) { false }
        let(:marketing_manager?) { true }
        let(:marketing_executive?) { true }
        let(:super_admin?) { true }
      end
    end

    context "with unreasonable terms" do
      let(:discount_cents) { 10_000 }
      let(:maximum_usages) { -1 }

      describe "#violations" do
        subject { judgement.violations }

        let(:roles) { MarketingManagerRole }

        before { judge }

        it { is_expected.to match_array [ instance_of(DiscountManagerRegulation) ] }

        describe "#errors.details" do
          subject { judgement.violations.map(&:errors).map(&:details) }

          let(:params_errors) do
            { params_discount_cents: [ count: 2000, error: :less_than_or_equal_to, value: 10_000 ],
              params_maximum_usages: [ count: 1, error: :greater_than_or_equal_to, value: -1 ] }
          end

          it { is_expected.to eq([ params_errors ]) }
        end
      end

      it_behaves_like "an enforced statute" do
        let(:guest?) { false }
        let(:user?) { false }
        let(:admin?) { false }
        let(:marketing_manager?) { false }
        let(:marketing_executive?) { true }
        let(:super_admin?) { true }
      end
    end
  end
end
