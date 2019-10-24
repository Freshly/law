# frozen_string_literal: true

RSpec.describe Law::Regulations::Core, type: :concern do
  include_context "with an example regulation"

  it { is_expected.to define_argument :petition }

  describe "#method_missing" do
    subject(:call) { example_regulation.public_send(method_name) }

    shared_examples_for "a NoMethodError is raised" do
      it "raises" do
        expect { call }.to raise_error NoMethodError
      end
    end

    context "with gibberish" do
      let(:method_name) { SecureRandom.hex.to_sym }

      it_behaves_like "a NoMethodError is raised"
    end

    context "with delegate" do
      let(:method_name) { "#{delegate_name}_#{delegated_method_name}".to_sym }
      let(:delegated_method_name) { SecureRandom.hex.to_sym }

      before { allow(petition).to receive(delegate_name).and_return(instance) }

      context "when class" do
        let(:delegate_name) { %i[source target].sample }
        let(:instance) { delegate.new }

        context "without delegated_method_name" do
          let(:delegate) { Class.new }

          it_behaves_like "a NoMethodError is raised"
        end

        context "with delegated_method_name" do
          let(:delegate) do
            Class.new.tap do |klass|
              klass.define_method(delegated_method_name) { :result_from_class_delegate }
            end
          end

          it { is_expected.to eq :result_from_class_delegate }
        end
      end

      context "when hash" do
        let(:delegate_name) { :params }

        context "without key" do
          let(:instance) { {} }

          it_behaves_like "a NoMethodError is raised"
        end

        context "with symbolic key" do
          let(:instance) { Hash[delegated_method_name, :result_from_hash] }

          it { is_expected.to eq :result_from_hash }
        end

        context "with string key" do
          let(:instance) { Hash[delegated_method_name.to_s, :result_from_hash] }

          it { is_expected.to eq :result_from_hash }
        end
      end

      context "when something else" do
        let(:delegate_name) { %i[source target].sample }
        let(:instance) { SecureRandom.hex }

        it_behaves_like "a NoMethodError is raised"
      end
    end
  end
end
