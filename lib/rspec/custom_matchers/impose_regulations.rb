# frozen_string_literal: true

# RSpec matcher that tests imposing of regulations by laws.
#
#     class ExampleRegulation < ApplicationRegulation
#       desc "A short sentence to contextualize the reason this regulation exists."
#     end
#
#     class ExampleLaw < ApplicationLaw
#       impose ExampleRegulation
#     end
#
#     RSpec.describe ExampleLaw, type: :law do
#       it { is_expected.to impose_regulations ExampleRegulation }
#     end

RSpec::Matchers.define :impose_regulations do |*regulations|
  match { expect(test_subject.regulations).to match_array Array.wrap(regulations).flatten }
  description { "impose regulations #{Array.wrap(regulations).flatten}" }
  failure_message { "expected #{test_subject} to impose regulations #{Array.wrap(regulations).flatten}" }
  failure_message_when_negated do
    "expected #{test_subject} not to impose regulations #{Array.wrap(regulations).flatten}"
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
