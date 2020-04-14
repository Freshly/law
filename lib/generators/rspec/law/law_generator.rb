# frozen_string_literal: true

module Rspec
  module Generators
    class LawGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_spec_file
        template "law_spec.rb.erb", File.join("spec/laws/", class_path, "#{file_name}_law_spec.rb")
      end
    end
  end
end
