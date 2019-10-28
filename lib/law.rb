# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/enumerable"

require "spicerack"

require "law/version"

require "law/permission_base"
require "law/regulation_base"

require "law/role_base"
require "law/actor_base"

require "law/statute_base"

require "law/petition"
require "law/judgement"

module Law
  class Error < StandardError; end

  class AlreadyJudgedError < Error; end

  class NotAuthorizedError < Error; end
  class InjunctionError < NotAuthorizedError; end
end
