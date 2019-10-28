# frozen_string_literal: true

# RSpec matcher that tests imposing of regulations by statutes.
#
#     class ExampleRegulation < ApplicationRegulation
#     end
#
#     class ExampleStatute < ApplicationStatute
#       impose ExampleRegulation
#     end
#
#     RSpec.describe ExampleStatute, type: :statute do
#       it { is_expected.to impose_regulations ExampleRegulation }
#     end

RSpec::Matchers.define :impose_regulations do |*regulations|
  match { expect(test_subject.regulations).to include *Array.wrap(regulations).flatten }
  description { "impose regulations #{Array.wrap(regulations).flatten}" }
  failure_message do
    "expected #{test_subject} to impose regulations #{Array.wrap(regulations).flatten}; #{test_subject.regulations}"
  end
  failure_message_when_negated do
    "expected #{test_subject} not to impose regulations #{Array.wrap(regulations).flatten}; #{test_subject.regulations}"
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
