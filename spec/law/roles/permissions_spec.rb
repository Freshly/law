# frozen_string_literal: true

RSpec.describe Law::Roles::Permissions, type: :concern do
  include_context "with an example role"

  describe ".grant" do
    subject(:grant) { example_role_class.__send__(:grant, input) }

    let(:valid_permission) do
      Class.new do
        def self.granted_to(*); end
      end
    end

    before { allow(valid_permission).to receive(:granted_to) }

    context "with one" do
      context "when valid" do
        let(:input) { valid_permission }

        it "is assigned" do
          expect { grant }.to change { example_role_class.permissions }.from([]).to([ input ])
          expect(valid_permission).to have_received(:granted_to).with(example_role_class)
        end
      end

      context "when nil" do
        let(:input) { nil }

        it "is raises" do
          expect { grant }.to raise_error ArgumentError, "a permission is required"
        end
      end

      context "when invalid" do
        let(:input) { Faker::Lorem.word }

        it "is raises" do
          expect { grant }.to raise_error ArgumentError, "invalid permissions: #{input}"
        end
      end
    end

    context "with many" do
      context "when all valid" do
        let(:input) do
          # Generally you shouldn't need to include the same permissions multiple times, but it equivalent for testing.
          Array.new(3) { valid_permission }
        end

        it "is assigned" do
          expect { grant }.to change { example_role_class.permissions }.from([]).to(input)
          expect(valid_permission).to have_received(:granted_to).with(example_role_class).exactly(3).times
        end
      end

      context "when some invalid" do
        let(:input) { [ valid_permission, invalid_permission ] }

        let(:invalid_permission) { Faker::Lorem.word }

        it "is raises" do
          expect { grant }.to raise_error ArgumentError, "invalid permissions: #{invalid_permission}"
        end
      end

      context "when all invalid" do
        let(:input) { [ invalid_permission0, invalid_permission1 ] }

        let(:invalid_permission0) { SecureRandom.hex }
        let(:invalid_permission1) { SecureRandom.hex }

        it "is raises" do
          expect { grant }.to raise_error ArgumentError, "invalid permissions: #{input.join(", ")}"
        end
      end
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :grant, :permissions do
      let(:root_class) do
        Class.new(Law::RoleBase) do
          # This is a test for the values being properly inherited, validations are not required and tested elsewhere.
          def self.ensure_valid_permissions(*); end
          def self.track_permission(*); end
        end
      end
    end
  end
end