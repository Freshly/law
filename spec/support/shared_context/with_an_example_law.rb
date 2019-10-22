# frozen_string_literal: true

RSpec.shared_context "with an example law" do
  subject(:example_law) { example_law_class.new }

  let(:example_law_class) do
    Class.new(Law::LawBase).tap { |klass| klass.__send__(:desc, description) }
  end

  let(:description) { Faker::Lorem.sentence }

  let(:root_name) { Faker::Internet.domain_word.capitalize }
  let(:example_law_name) { "#{root_name}Law" }

  before { stub_const(example_law_name, example_law_class) }
end
