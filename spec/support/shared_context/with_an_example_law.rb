# frozen_string_literal: true

RSpec.shared_context "with an example law" do
  subject(:example_law) do
    example_law_class.new(source: source, permissions: permissions, target: target, params: params)
  end

  let(:source) { nil }
  let(:permissions) { [] }
  let(:target) { nil }
  let(:params) { {} }

  let(:example_law_class) { Class.new(Law::LawBase) }

  let(:root_name) { Faker::Alphanumeric.alpha(number: rand(6..18)).capitalize }
  let(:example_law_name) { "#{root_name}Law" }

  before { stub_const(example_law_name, example_law_class) }
end
