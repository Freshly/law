# frozen_string_literal: true

require_relative "laws/regulations"

# A **Law** restricts actions to **Actors** by enforcing a collection of **Permissions**.
module Law
  class LawBase < DescribableObject
    include Law::Laws::Regulations

    type_name "Law"
  end
end
