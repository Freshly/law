# frozen_string_literal: true

RSpec.describe Law::Judgement, type: :integration do
  include_context "with an example petition"

  subject(:judge) { described_class.judge(example_petition) }

  shared_examples_for "an enforced law" do
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

  context "when unregulated" do
    let(:law) { UnregulatedLaw }

    it_behaves_like "an enforced law" do
      let(:guest?) { true }
      let(:user?) { true }
      let(:admin?) { true }
      let(:marketing_manager?) { true }
      let(:marketing_executive?) { true }
      let(:super_admin?) { true }
    end
  end

  context "with CommonLaw" do
    let(:law) { CommonLaw }

    it_behaves_like "an enforced law" do
      let(:guest?) { false }
      let(:user?) { false }
      let(:admin?) { false }
      let(:marketing_manager?) { false }
      let(:marketing_executive?) { false }
      let(:super_admin?) { true }
    end
  end

  context "with AuthenticationLaw" do
    let(:law) { AuthenticationLaw }

    it_behaves_like "an enforced law" do
      let(:guest?) { false }
      let(:user?) { true }
      let(:admin?) { true }
      let(:marketing_manager?) { true }
      let(:marketing_executive?) { true }
      let(:super_admin?) { true }
    end
  end

  context "with AdminLaw" do
    let(:law) { AdminLaw }

    it_behaves_like "an enforced law" do
      let(:guest?) { false }
      let(:user?) { false }
      let(:admin?) { true }
      let(:marketing_manager?) { true }
      let(:marketing_executive?) { true }
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

      describe "Errors" do
        it "needs specs"
      end

      it_behaves_like "an enforced law" do
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

      describe "Errors" do
        it "needs specs"
      end

      it_behaves_like "an enforced law" do
        let(:guest?) { false }
        let(:user?) { false }
        let(:admin?) { true }
        let(:marketing_manager?) { true }
        let(:marketing_executive?) { true }
        let(:super_admin?) { true }
      end
    end
  end

  context "with CreateDiscountLaw" do
    let(:law) { CreateDiscountLaw }

    describe "Errors" do
      it "needs specs"
    end

    it "needs context and specs"

    # it_behaves_like "an enforced law" do
    #   let(:guest?) { false }
    #   let(:user?) { false }
    #   let(:admin?) { false }
    #   let(:marketing_manager?) { true }
    #   let(:marketing_executive?) { true }
    #   let(:super_admin?) { true }
    # end
  end
end
