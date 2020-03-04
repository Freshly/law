# frozen_string_literal: true

require_relative "statutes/regulations"
require_relative "statutes/laws"
require_relative "statutes/compliance"

# A **Statute** restricts actions to **Actors** by enforcing a collection of **Permissions**.
module Law
  class StatuteBase < Spicerack::RootObject
    include Law::Statutes::Regulations
    include Law::Statutes::Laws
    include Law::Statutes::Compliance
  end
end
