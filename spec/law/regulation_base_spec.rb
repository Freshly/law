# frozen_string_literal: true

RSpec.describe Law::RegulationBase, type: :regulation do
  include_context "with an example regulation"

  it { is_expected.to inherit_from Law::DescribableObject }

  it_behaves_like "a describable object" do
    let(:example_class) { example_regulation_class }
  end
end
