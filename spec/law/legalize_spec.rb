# frozen_string_literal: true

RSpec.describe Law::Legalize, type: :concern do
  let(:legalized_object) { legalized_class.new }
  let(:legalized_class) do
    Class.new.tap { |klass| klass.include described_class }
  end

  it "needs specs"
end
