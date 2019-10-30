# frozen_string_literal: true

# RSpec matcher that tests references of statutes in laws.
#
#     class ExampleStatute < ApplicationStatute
#     end
#
#     class ExampleLaw < ApplicationStatute
#       define_action :new, enforces: ExampleRegulation
#       define_action :create, enforces: ExampleRegulation
#     end
#
#     RSpec.describe ExampleStatute, type: :statute do
#       it { is_expected.to be_enforced_by ExampleLaw, :new, :create }
#     end

RSpec::Matchers.define :be_enforced_by do |statute, *methods|
  match { expect(test_subject.laws).to include(statute => a_collection_including(*methods.flatten)) }
  description { "be enforced by #{statute} on #{methods.flatten.join(", ")}" }
  failure_message do
    "expected #{test_subject} to be enforced by #{statute} on #{methods.flatten.join(", ")}; #{test_subject.laws}"
  end
  failure_message_when_negated do
    "expected #{test_subject} not to be enforced by #{statute} on #{methods.flatten.join(", ")}; #{test_subject.laws}"
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
