# frozen_string_literal: true

# A **Petition** is used to make a **Judgement** determining if an action would violate a given **Statute**.
module Law
  class Petition < Spicerack::InputObject
    argument :statute, allow_nil: false
    option :source
    option :permissions, default: []
    option :target
    option :params, default: {}

    def permission_list
      Law::PermissionList.new(Array.wrap(permissions).flatten.compact)
    end
    memoize :permission_list

    def applicable_regulations
      statute.regulations.select { |regulation| permission_list.include? regulation.key }
    end
    memoize :applicable_regulations
  end
end
