# frozen_string_literal: true

RSpec.describe Law::Regulations::Laws, type: :concern do
  include_context "with an example regulation"

  describe ".enforced_by" do
    subject(:enforced_by) { example_regulation_class.enforced_by law }

    let(:law) { double }

    it "tracks" do
      expect { enforced_by }.to change { example_regulation_class.laws }.from([]).to([ law ])
    end
  end

  describe ".inherited" do
    subject(:inherited_regulation_class) { Class.new(example_regulation_class) }

    before { example_regulation_class.enforced_by law }

    let(:law) { double }

    it "is not inherited" do
      expect(inherited_regulation_class.laws).to eq []
      expect(example_regulation_class.laws).to eq [ law ]
    end
  end
end
