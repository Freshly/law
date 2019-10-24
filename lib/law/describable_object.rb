# frozen_string_literal: true

# An abstraction that DRYs out the lock and key system of regulations and permissions.
module Law
  class DescribableObject < Spicerack::RootObject
    include Describable
  end
end
