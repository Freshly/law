# frozen_string_literal: true

RSpec.shared_context "with roles and permissions" do
  include_context "with lock and key names"

  let(:permission0) { Class.new(Law::PermissionBase) }
  let(:permission1) { Class.new(Law::PermissionBase) }
  let(:permission2) { Class.new(Law::PermissionBase) }

  let(:role0) do
    Class.new(Law::RoleBase).tap { |klass| klass.__send__(:grant, permission0, permission1) }
  end
  let(:role1) do
    Class.new(Law::RoleBase).tap { |klass| klass.__send__(:grant, permission1, permission2) }
  end

  before do
    stub_const(permission0_name, permission0)
    stub_const(permission1_name, permission1)
    stub_const(permission2_name, permission2)
  end
end
