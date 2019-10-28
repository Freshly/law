# frozen_string_literal: true

module Law
  class PermissionList < Collectible::CollectionBase
    ensures_item_class Symbol
  end
end
