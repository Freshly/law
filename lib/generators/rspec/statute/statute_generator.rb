# frozen_string_literal: true

module Rspec
  module Generators
    class StatuteGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_spec_file
        template "statute_spec.rb.erb", File.join("spec/statutes/", class_path, "#{file_name}_statute_spec.rb")
      end
    end
  end
end
