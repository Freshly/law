# frozen_string_literal: true

# RSpec matcher that tests references of laws to regulations.
#
#     class ExampleRegulation < ApplicationRegulation
#       desc "A short sentence to contextualize the reason this regulation exists."
#     end
#
#     class ExampleLaw < ApplicationRole
#       impose ExampleRegulation
#     end
#
#     RSpec.describe ExampleRegulation, type: :regulation do
#       it { is_expected.to be_imposed_by ExampleLaw }
#     end

RSpec::Matchers.define :be_imposed_by do |*laws|
  match { expect(test_subject.laws).to include *Array.wrap(laws).flatten }
  description { "be imposed by #{Array.wrap(laws).flatten}" }
  failure_message do
    "expected #{test_subject} to be imposed by #{Array.wrap(laws).flatten}; #{test_subject.laws}"
  end
  failure_message_when_negated do
    "expected #{test_subject} not to be imposed by #{Array.wrap(laws).flatten}; #{test_subject.laws}"
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
