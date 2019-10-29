# frozen_string_literal: true

class DiscountLaw < AdminLaw
  define_action :new, :create, enforces: CreateDiscountStatute
end
