# frozen_string_literal: true

module Law
  module Generators
    class LawGenerator < Rails::Generators::NamedBase
      class_option :statute, type: :boolean, default: true
      class_option :regulation, type: :boolean, default: true

      source_root File.expand_path("templates", __dir__)

      hook_for :test_framework

      def create_application_flow
        template "law.rb.erb", File.join("app/laws/", class_path, "#{file_name}_law.rb")
      end
    end
  end
end
