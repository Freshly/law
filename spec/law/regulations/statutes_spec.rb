# frozen_string_literal: true

RSpec.describe Law::Regulations::Statutes, type: :concern do
  include_context "with an example regulation"

  describe ".imposed_by" do
    subject(:imposed_by) { example_regulation_class.imposed_by statute }

    let(:statute) { double }

    it "tracks" do
      expect { imposed_by }.to change { example_regulation_class.statutes }.from([]).to([ statute ])
    end
  end

  describe ".inherited" do
    subject(:inherited_regulation_class) { Class.new(example_regulation_class) }

    before { example_regulation_class.imposed_by statute }

    let(:statute) { double }

    it "is not inherited" do
      expect(inherited_regulation_class.statutes).to eq []
      expect(example_regulation_class.statutes).to eq [ statute ]
    end
  end
end
