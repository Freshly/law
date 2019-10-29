# frozen_string_literal: true

# RSpec matcher that tests references of statutes in laws.
#
#     class ExampleStatute < ApplicationStatute
#     end
#
#     class ExampleLaw < ApplicationStatute
#       define_action :new, enforces: ExampleRegulation
#       define_action :create, enforces: ExampleRegulation
#       define_action :edit
#     end
#
#     RSpec.describe ExampleLaw, type: :law do
#       it { is_expected.to define_action :new, with_statute: ExampleRegulation }
#       it { is_expected.to define_action :edit, with_statute: :default }
#     end

RSpec::Matchers.define :define_action do |action, with_statute:|
  match do
    for_default = with_statute == :default
    expect(test_subject.actions[action]).to eq with_statute unless for_default
    expect(test_subject.statute_for_action?(action)).to eq !for_default
  end
  description { "define action #{action} with statute #{with_statute}" }
  failure_message do
    "expected #{test_subject} to define action #{action}, statute: #{with_statute}; #{test_subject.actions[action]}"
  end
  failure_message_when_negated do
    "expected #{test_subject} not to define action #{action}, statute: #{with_statute}; #{test_subject.actions[action]}"
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
