# frozen_string_literal: true

module Law
  module Generators
    class StatuteGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      hook_for :test_framework

      def create_application_statute
        template "statute.rb.erb", File.join("app/statutes/", class_path, "#{file_name}_statute.rb")
      end
    end
  end
end
