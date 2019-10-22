# frozen_string_literal: true

RSpec.describe Law::Laws::Regulations, type: :concern do
  include_context "with an example law"

  describe ".impose" do
    subject(:impose) { example_law_class.__send__(:impose, input) }

    let(:valid_regulation) do
      Class.new do
        def self.imposed_by(*); end
      end
    end

    before { allow(valid_regulation).to receive(:imposed_by) }

    context "with one" do
      context "when valid" do
        let(:input) { valid_regulation }

        it "is assigned" do
          expect { impose }.to change { example_law_class.regulations }.from([]).to([ input ])
          expect(valid_regulation).to have_received(:imposed_by).with(example_law_class)
        end
      end

      context "when nil" do
        let(:input) { nil }

        it "is raises" do
          expect { impose }.to raise_error ArgumentError, "a regulation is required"
        end
      end

      context "when invalid" do
        let(:input) { Faker::Lorem.word }

        it "is raises" do
          expect { impose }.to raise_error ArgumentError, "invalid regulations: #{input}"
        end
      end
    end

    context "with many" do
      context "when all valid" do
        let(:input) do
          # Generally you shouldn't need to include the same regulation multiple times, but it equivalent for testing.
          Array.new(3) { valid_regulation }
        end

        it "is assigned" do
          expect { impose }.to change { example_law_class.regulations }.from([]).to(input)
          expect(valid_regulation).to have_received(:imposed_by).with(example_law_class).exactly(3).times
        end
      end

      context "when some invalid" do
        let(:input) { [ valid_regulation, invalid_regulation ] }

        let(:invalid_regulation) { Faker::Lorem.word }

        it "is raises" do
          expect { impose }.to raise_error ArgumentError, "invalid regulations: #{invalid_regulation}"
        end
      end

      context "when all invalid" do
        let(:input) { [ invalid_regulation0, invalid_regulation1 ] }

        let(:invalid_regulation0) { SecureRandom.hex }
        let(:invalid_regulation1) { SecureRandom.hex }

        it "is raises" do
          expect { impose }.to raise_error ArgumentError, "invalid regulations: #{input.join(", ")}"
        end
      end
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :impose, :regulations do
      let(:root_class) do
        Class.new(Law::LawBase) do
          # This is a test for the values being properly inherited, validations are not required and tested elsewhere.
          def self.ensure_valid_regulations(*); end
          def self.track_regulation(*); end
        end
      end
    end
  end
end
