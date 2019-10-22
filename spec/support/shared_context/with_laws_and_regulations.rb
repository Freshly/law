# frozen_string_literal: true

RSpec.shared_context "with laws and regulations" do
  include_context "with lock and key names"

  let(:regulation0) { Class.new(Law::RegulationBase) }
  let(:regulation1) { Class.new(Law::RegulationBase) }
  let(:regulation2) { Class.new(Law::RegulationBase) }

  let(:law0) do
    Class.new(Law::LawBase).tap { |klass| klass.__send__(:impose, regulation0, regulation1) }
  end
  let(:law1) do
    Class.new(Law::LawBase).tap { |klass| klass.__send__(:impose, regulation1, regulation2) }
  end

  before do
    stub_const(regulation0_name, regulation0)
    stub_const(regulation1_name, regulation1)
    stub_const(regulation2_name, regulation2)
  end
end
