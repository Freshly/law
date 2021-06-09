# frozen_string_literal: true

RSpec.shared_context "with an example regulation" do
  subject(:example_regulation) { example_regulation_class.new(petition: petition) }

  let(:example_regulation_class) { Class.new(Law::RegulationBase) }

  let(:petition) { instance_double(Law::Petition) }

  let(:root_name) { Faker::Alphanumeric.alpha(number: rand(6..18)).capitalize }
  let(:example_regulation_name) { "#{root_name}Regulation" }

  before { stub_const(example_regulation_name, example_regulation_class) }
end
