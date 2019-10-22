# frozen_string_literal: true

RSpec.describe Law::Regulations::Laws, type: :concern do
  include_context "with an example regulation"

  describe ".imposed_by" do
    subject(:imposed_by) { example_regulation_class.imposed_by law }

    let(:law) { double }

    it "tracks" do
      expect { imposed_by }.to change { example_regulation_class.laws }.from([]).to([ law ])
    end
  end

  describe ".inherited" do
    subject(:inherited_regulation_class) { Class.new(example_regulation_class) }

    before { example_regulation_class.imposed_by law }

    let(:law) { double }

    it "is not inherited" do
      expect(inherited_regulation_class.laws).to eq []
      expect(example_regulation_class.laws).to eq [ law ]
    end
  end
end
