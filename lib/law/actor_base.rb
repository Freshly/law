# frozen_string_literal: true

require_relative "actors/permissions"

# An **Actor** has a collection of **Permissions** granted to it by **Roles**.
module Law
  class ActorBase < Spicerack::InputObject
    include Law::Actors::Permissions
  end
end
