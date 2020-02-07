# frozen_string_literal: true

RSpec.shared_context "with statutes and regulations" do
  let(:root_name) { Faker::Internet.domain_word.capitalize }

  let(:regulation0_name) { "#{root_name}xRegulation" }
  let(:regulation1_name) { "#{root_name}yRegulation" }
  let(:regulation2_name) { "#{root_name}zRegulation" }

  let(:regulation0) { Class.new(Law::RegulationBase) }
  let(:regulation1) { Class.new(Law::RegulationBase) }
  let(:regulation2) { Class.new(Law::RegulationBase) }

  let(:statute0) do
    Class.new(Law::StatuteBase).tap { |klass| klass.__send__(:impose, regulation0, regulation1) }
  end
  let(:statute1) do
    Class.new(Law::StatuteBase).tap { |klass| klass.__send__(:impose, regulation1, regulation2) }
  end

  before do
    stub_const(regulation0_name, regulation0)
    stub_const(regulation1_name, regulation1)
    stub_const(regulation2_name, regulation2)
  end
end
