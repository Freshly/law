# frozen_string_literal: true

# Basic law from which all others are derived; defines the default statute for the Application.
class ApplicationLaw < Law::LawBase
  default_statute UnregulatedStatute

  define_action :preview
  define_action :index, :show, enforces: AuthenticationStatute
  define_action :new, :create, :edit, :update, :destroy, enforces: AdminStatute
end
