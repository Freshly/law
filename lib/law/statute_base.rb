# frozen_string_literal: true

require_relative "statutes/regulations"

# A **Statute** restricts actions to **Actors** by enforcing a collection of **Permissions**.
module Law
  class StatuteBase < Spicerack::RootObject
    include Law::Statutes::Regulations
  end
end
