# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/enumerable"

require "spicerack"

require "law/version"

require "law/concerns/describable"

require "law/describable_object"
require "law/permission_base"
require "law/regulation_base"

require "law/role_base"
require "law/actor_base"

require "law/law_base"

require "law/petition"
require "law/judgement"

module Law
  class NotAuthorizedError < StandardError; end
  class InjunctionError < NotAuthorizedError; end
end
