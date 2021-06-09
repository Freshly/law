# frozen_string_literal: true

RSpec.shared_context "with petition data" do
  let(:statute) { Class.new(Law::StatuteBase) }
  let(:source) { double }
  let(:target) { double }
  let(:params) { Hash[*Faker::Lorem.words(number: 2 * rand(1..2))] }
  let(:permissions) { [ Faker::Alphanumeric.alpha(number: rand(6..18)).to_sym ] }
end
