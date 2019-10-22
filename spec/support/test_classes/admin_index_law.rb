# frozen_string_literal: true

class AdminIndexLaw < Law::LawBase
  desc "Restricts listing of sensitive objects intended only for Administrators."

  impose DoAnythingRegulation, AdministrativeRegulation
end
