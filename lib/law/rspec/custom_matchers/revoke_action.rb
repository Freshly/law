# frozen_string_literal: true

# RSpec matcher that tests revoking of statutes in laws.
#
#     class ExampleStatute < ApplicationStatute
#     end
#
#     class CommonLaw < ApplicationStatute
#       define_action :new, enforces: ExampleRegulation
#       define_action :create, enforces: ExampleRegulation
#       define_action :edit
#     end
#
#     class ExampleLaw < CommonLaw
#       revoke_action :new, :edit
#     end
#
#     RSpec.describe ExampleLaw, type: :law do
#       it { is_expected.to revoke_action :new, :edit }
#     end

RSpec::Matchers.define :revoke_action do |*actions|
  match do
    actions.each { |action| expect(test_subject.revoked_action?(action)).to eq true }
  end
  description { "revoke #{"action".pluralize(actions.length)} #{actions.join(", ")}" }
  failure_message { "expected #{test_subject} to revoke #{"action".pluralize(actions.length)} #{actions.join(", ")}" }
  failure_message_when_negated do
    "expected #{test_subject} not to revoke #{"action".pluralize(actions.length)} #{actions.join(", ")}"
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
