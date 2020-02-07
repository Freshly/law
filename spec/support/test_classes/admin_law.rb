# frozen_string_literal: true

# Specialized law which locks down index and show operations to administrators.
class AdminLaw < ApplicationLaw
  default_statute AdminStatute

  define_action :index, :show, enforces: AdminStatute
end
