# frozen_string_literal: true

# RSpec matcher that tests grants of permissions to roles.
#
#     class ExamplePermission < ApplicationPermission
#       desc "A short sentence to contextualize the reason this permission exists."
#     end
#
#     class ExampleRole < ApplicationRole
#       grants ExamplePermission
#     end
#
#     RSpec.describe ExampleRole do
#       it { is_expected.to have_permissions ExamplePermission }
#     end

RSpec::Matchers.define :have_permissions do |*permissions|
  match { expect(test_subject.permissions).to match_array *Array.wrap(permissions).flatten }
  description { "have permissions #{Array.wrap(permissions).flatten}" }
  failure_message { "expected #{test_subject} to have permissions #{Array.wrap(permissions).flatten}" }
  failure_message_when_negated { "expected #{test_subject} not to have permissions #{Array.wrap(permissions).flatten}" }

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
