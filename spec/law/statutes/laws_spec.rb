# frozen_string_literal: true

RSpec.describe Law::Statutes::Laws, type: :concern do
  include_context "with an example statute"

  let(:law) { Class.new(Law::LawBase) }
  let(:action) { Faker::Internet.domain_word.to_sym }

  describe ".enforced_by" do
    subject(:enforced_by) { example_statute_class.enforced_by law, action }

    it "tracks" do
      expect { enforced_by }.to change { example_statute_class.laws }.from({}).to(law => [ action ])
    end
  end

  describe ".inherited" do
    subject(:inherited_statute_class) { Class.new(example_statute_class) }

    before { example_statute_class.enforced_by law, action }

    it "is not inherited" do
      expect(inherited_statute_class.laws).to eq({})
      expect(example_statute_class.laws).to eq(law => [ action ])
    end
  end
end
