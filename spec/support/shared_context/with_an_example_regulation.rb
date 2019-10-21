# frozen_string_literal: true

RSpec.shared_context "with an example regulation" do
  subject(:example_regulation_class) do
    Class.new(Law::RegulationBase).tap { |klass| klass.__send__(:desc, description) }
  end

  let(:description) { Faker::Lorem.sentence }

  let(:root_name) { Faker::Internet.domain_word.capitalize }
  let(:example_regulation_name) { "#{root_name}Regulation" }

  before { stub_const(example_regulation_name, example_regulation_class) }
end
