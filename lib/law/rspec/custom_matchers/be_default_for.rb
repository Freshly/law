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
#     RSpec.describe ExampleStatute, type: :statute do
#       it { is_expected.to be_default_for ExampleLaw }
#     end

RSpec::Matchers.define :be_default_for do |*laws|
  match do
    laws.each { |law| expect(test_subject.laws).to include(law => a_collection_including(:__default__)) }
  end
  description { "be default for #{Array.wrap(laws).join(", ")}" }
  failure_message do
    "expected #{test_subject} to be default for #{Array.wrap(laws).join(", ")}; #{test_subject.laws}"
  end
  failure_message_when_negated do
    "expected #{test_subject} not to be default for #{Array.wrap(laws).join(", ")}; #{test_subject.laws}"
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
