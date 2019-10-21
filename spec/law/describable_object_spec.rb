# frozen_string_literal: true

RSpec.describe Law::DescribableObject, type: :object do
  include_context "with an example describable object"

  it { is_expected.to inherit_from Spicerack::RootObject }

  it { is_expected.to delegate_method(:key).to(:class) }
  it { is_expected.to delegate_method(:description).to(:class) }

  it_behaves_like "a describable object" do
    let(:example_class) { example_describable_class }
  end
end
