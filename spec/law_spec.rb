# frozen_string_literal: true

RSpec.describe Law do
  it "has a version number" do
    expect(Law::VERSION).not_to be_nil
  end

  describe described_class::Error do
    it { is_expected.to inherit_from StandardError }
  end

  describe described_class::AlreadyJudgedError do
    it { is_expected.to inherit_from Law::Error }
  end

  describe described_class::NotAuthorizedError do
    it { is_expected.to inherit_from Law::Error }
  end

  describe described_class::InjunctionError do
    it { is_expected.to inherit_from Law::NotAuthorizedError }
  end

  describe described_class::ComplianceError do
    it { is_expected.to inherit_from Law::NotAuthorizedError }
  end
end
