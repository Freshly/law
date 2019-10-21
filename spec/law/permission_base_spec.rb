# frozen_string_literal: true

RSpec.describe Law::PermissionBase, type: :permission do
  include_context "with an example permission"

  it { is_expected.to inherit_from Law::DescribableObject }

  it { is_expected.to include_module Law::Permissions::Roles }

  it_behaves_like "a describable object" do
    let(:example_class) { example_permission_class }
  end
end
