# frozen_string_literal: true

require "bundler/setup"
require "pry"
require "simplecov"

require "timecop"

require "spicerack/spec_helper"
require "shoulda-matchers"

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/rspec/"
end

require "law"

require_relative "support/shared_context/with_an_example_describable_object"
require_relative "support/shared_context/with_an_example_permission"
require_relative "support/shared_context/with_an_example_regulation"

require_relative "support/shared_context/with_an_example_role"
require_relative "support/shared_context/with_an_example_actor"

require_relative "support/shared_example/a_describable_object"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each, type: :with_frozen_time) { Timecop.freeze(Time.now.round) }
  config.before(:each, type: :integration) { Timecop.freeze(Time.now.round) }

  config.after(:each) { Timecop.return }
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
  end
end
