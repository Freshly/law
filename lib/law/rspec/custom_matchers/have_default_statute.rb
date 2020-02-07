# frozen_string_literal: true

# RSpec matcher that tests references of statutes as defaults in laws.
#
#     class ExampleStatute < ApplicationStatute
#     end
#
#     class ExampleLaw < ApplicationStatute
#       default_statute ExampleStatute
#     end
#
#     RSpec.describe ExampleLaw, type: :law do
#       it { is_expected.to have_default_statute ExampleStatute }
#     end

RSpec::Matchers.define :have_default_statute do |statute|
  match { expect(test_subject._default_statute).to eq statute }
  description { "have default statute #{statute}" }
  failure_message { "expected #{test_subject} to have default statute #{statute}; #{test_subject._default_statute}" }
  failure_message_when_negated do
    "expected #{test_subject} not to have default statute #{statute}; #{test_subject._default_statute}"
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
