# frozen_string_literal: true

# Restriction requiring the current actor to own the object being modified.
class OwnerRegulation < Law::RegulationBase
  validate :must_own_target

  private

  def must_own_target
    errors.add(:target, :does_not_own) unless target_user_id == source_id
  end
end
