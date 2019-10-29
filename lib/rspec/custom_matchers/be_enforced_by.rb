# frozen_string_literal: true

# RSpec matcher that tests references of statutes in laws.
#
#     class ExampleStatute < ApplicationStatute
#     end
#
#     class ExampleLaw < ApplicationStatute
#       action :new, enforces: ExampleRegulation
#       action :create, enforces: ExampleRegulation
#     end
#
#     RSpec.describe ExampleRegulation, type: :regulation do
#       it { is_expected.to be_enforced_by ExampleLaw => %i[new create] }
#     end

RSpec::Matchers.define :be_enforced_by do |hash|
  match { expect(test_subject.laws).to include hash }
  description { "be imposed by #{hash}" }
  failure_message { "expected #{test_subject} to be imposed by #{hash}; #{test_subject.laws}" }
  failure_message_when_negated { "expected #{test_subject} not to be imposed by #{hash}; #{test_subject.laws}" }

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
