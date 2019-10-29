# frozen_string_literal: true

RSpec.shared_context "with petition data" do
  let(:statute) { Class.new(Law::StatuteBase) }
  let(:source) { double }
  let(:target) { double }
  let(:params) { Hash[*Faker::Lorem.words(2 * rand(1..2))] }
  let(:permissions) { [ Faker::Internet.domain_word.to_sym ] }
end
