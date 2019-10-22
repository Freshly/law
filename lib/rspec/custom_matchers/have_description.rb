# frozen_string_literal: true

# RSpec matcher that tests usages of describable objects specifying a description.
#
#     class ExamplePermission < ApplicationPermission
#       desc "A short sentence to contextualize the reason this permission exists."
#     end
#
#     class ExampleRegulation < ApplicationRegulation
#       desc "A short sentence to contextualize the reason this regulation exists."
#     end
#
#     RSpec.describe ExamplePermission do
#       it { is_expected.to have_description "A short sentence to contextualize the reason this permission exists." }
#     end
#
#     RSpec.describe ExampleRegulation do
#       it { is_expected.to have_description "A short sentence to contextualize the reason this regulation exists." }
#     end

RSpec::Matchers.define :have_description do |description|
  match { expect(actual_description).to eq description }
  description { "have description #{description}" }
  failure_message do
    "expected #{test_subject} to have description '#{description}'#{" but had '#{actual_description}'" if actual?}"
  end
  failure_message_when_negated { "expected #{test_subject} not to have description #{description}" }

  def actual?
    actual_description.present?
  end

  def actual_description
    test_subject.description
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
