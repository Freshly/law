# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/enumerable"

require "spicerack"

require "law/version"

require "law/regulation_base"

require "law/permission_list"

require "law/statute_base"

require "law/petition"
require "law/judgement"

require "law/law_base"

module Law
  class Error < StandardError; end

  class AlreadyJudgedError < Error; end

  class NotAuthorizedError < Error; end
  class InjunctionError < NotAuthorizedError; end
end
