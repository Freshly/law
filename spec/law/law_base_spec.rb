# frozen_string_literal: true

RSpec.describe Law::LawBase, type: :law do
  include_context "with an example law"

  it { is_expected.to inherit_from Law::DescribableObject }

  it { is_expected.to include_module Law::Laws::Regulations }

  it_behaves_like "a describable object" do
    let(:example_class) { example_law_class }
  end
end
