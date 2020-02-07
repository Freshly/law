# frozen_string_literal: true

# RSpec matcher that tests references of statutes to regulations.
#
#     class ExampleRegulation < ApplicationRegulation
#     end
#
#     class ExampleStatute < ApplicationStatute
#       impose ExampleRegulation
#     end
#
#     RSpec.describe ExampleRegulation, type: :regulation do
#       it { is_expected.to be_imposed_by ExampleStatute }
#     end

RSpec::Matchers.define :be_imposed_by do |*statutes|
  match { expect(test_subject.statutes).to include *Array.wrap(statutes).flatten }
  description { "be imposed by #{Array.wrap(statutes).flatten}" }
  failure_message do
    "expected #{test_subject} to be imposed by #{Array.wrap(statutes).flatten}; #{test_subject.statutes}"
  end
  failure_message_when_negated do
    "expected #{test_subject} not to be imposed by #{Array.wrap(statutes).flatten}; #{test_subject.statutes}"
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
