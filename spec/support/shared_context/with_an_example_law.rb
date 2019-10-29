# frozen_string_literal: true

RSpec.shared_context "with an example law" do
  subject(:example_law) { example_law_class.new }

  let(:example_law_class) { Class.new(Law::LawBase) }

  let(:root_name) { Faker::Internet.domain_word.capitalize }
  let(:example_law_name) { "#{root_name}Law" }

  before { stub_const(example_law_name, example_law_class) }
end
