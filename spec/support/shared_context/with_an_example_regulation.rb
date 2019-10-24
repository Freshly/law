# frozen_string_literal: true

RSpec.shared_context "with an example regulation" do
  subject(:example_regulation) { example_regulation_class.new(petition: petition) }

  let(:example_regulation_class) do
    Class.new(Law::RegulationBase).tap { |klass| klass.__send__(:desc, description) }
  end

  let(:petition) { instance_double(Law::Petition) }

  let(:description) { Faker::Lorem.sentence }

  let(:root_name) { Faker::Internet.domain_word.capitalize }
  let(:example_regulation_name) { "#{root_name}Regulation" }

  before { stub_const(example_regulation_name, example_regulation_class) }
end
