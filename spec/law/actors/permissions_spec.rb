# frozen_string_literal: true

RSpec.describe Law::Actors::Permissions, type: :concern do
  include_context "with an example actor"

  it { is_expected.to define_argument :roles, allow_nil: false }

  shared_context "with roles and permissions" do
    let(:permission0) { Class.new(Law::PermissionBase) }
    let(:permission1) { Class.new(Law::PermissionBase) }
    let(:permission2) { Class.new(Law::PermissionBase) }

    let(:permission0_name) { Faker::Internet.domain_word.capitalize }
    let(:permission1_name) { "#{permission0_name}x" }
    let(:permission2_name) { "#{permission0_name}y" }

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

  describe "#permissions" do
    include_context "with roles and permissions"

    subject { example_actor.permissions }

    context "with no roles" do
      it { is_expected.to eq [] }
    end

    context "with one role" do
      let(:roles) { role0 }

      it { is_expected.to match_array [ permission0, permission1 ] }
    end

    context "with many roles" do
      let(:roles) { [ role0, role1 ] }

      it { is_expected.to match_array [ permission0, permission1, permission2 ] }
    end
  end

  describe "#permissions_map" do
    include_context "with roles and permissions"

    let(:roles) { [ role0, role1 ] }

    subject { example_actor.permissions_map }

    let(:expected_hash) do
      Hash[permission0.key, permission0, permission1.key, permission1, permission2.key, permission2]
    end

    it { is_expected.to eq expected_hash }
  end

  describe "#permitted_to?" do
    include_context "with roles and permissions"

    subject { example_actor.permitted_to?(permission) }

    let(:roles) { role0 }

    context "without permission" do
      context "when class" do
        let(:permission) { permission2 }

        it { is_expected.to eq false }
      end

      context "when key" do
        let(:permission) { permission2.key }

        it { is_expected.to eq false }
      end
    end

    context "with permission" do
      context "when class" do
        let(:permission) { permission0 }

        it { is_expected.to eq true }
      end

      context "when key" do
        let(:permission) { permission0.key }

        it { is_expected.to eq true }
      end
    end
  end
end
