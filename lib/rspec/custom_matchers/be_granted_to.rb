# frozen_string_literal: true

# RSpec matcher that tests references of roles to permissions.
#
#     class ExamplePermission < ApplicationPermission
#       desc "A short sentence to contextualize the reason this permission exists."
#     end
#
#     class ExampleRole < ApplicationRole
#       grants ExamplePermission
#     end
#
#     RSpec.describe ExamplePermission, type: :permission do
#       it { is_expected.to be_granted_to ExampleRole }
#     end

RSpec::Matchers.define :be_granted_to do |*roles|
  match { expect(test_subject.roles).to include *Array.wrap(roles).flatten }
  description { "include roles #{Array.wrap(roles).flatten}" }
  failure_message { "expected #{test_subject} to include roles #{Array.wrap(roles).flatten}" }
  failure_message_when_negated { "expected #{test_subject} not to include roles #{Array.wrap(roles).flatten}" }

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end