# frozen_string_literal: true

require_relative "laws/regulations"

# A **Law** is a collection of **Regulations**.
module Law
  class LawBase < Spicerack::RootObject
    include Law::Laws::Regulations
  end
end
