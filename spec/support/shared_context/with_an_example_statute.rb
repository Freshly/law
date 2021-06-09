# frozen_string_literal: true

RSpec.shared_context "with an example statute" do
  subject(:example_statute) { example_statute_class.new }

  let(:example_statute_class) { Class.new(Law::StatuteBase) }

  let(:root_name) { Faker::Alphanumeric.alpha(number: rand(6..18)).capitalize }
  let(:example_statute_name) { "#{root_name}Statute" }

  before { stub_const(example_statute_name, example_statute_class) }
end
