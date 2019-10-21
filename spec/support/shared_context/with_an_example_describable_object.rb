# frozen_string_literal: true

RSpec.shared_context "with an example describable object" do
  subject(:example_describable) { example_describable_class.new }

  let(:example_describable_class) do
    Class.new(Law::DescribableObject).tap do |klass|
      klass.__send__(:type_name, type_name)
      klass.__send__(:desc, description)
    end
  end

  let(:type_name) { Faker::Internet.domain_word.capitalize }
  let(:description) { Faker::Lorem.sentence }

  let(:root_name) { Faker::Internet.domain_word.capitalize }
  let(:example_describable_name) { "#{root_name}#{type_name}" }

  before { stub_const(example_describable_name, example_describable_class) }
end
