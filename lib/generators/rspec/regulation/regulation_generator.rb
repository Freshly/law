# frozen_string_literal: true

module Rspec
  module Generators
    class RegulationGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_spec_file
        template "regulation_spec.rb.erb", File.join("spec/regulations/", class_path, "#{file_name}_regulation_spec.rb")
      end
    end
  end
end
