# frozen_string_literal: true

RSpec.shared_context "with lock and key names" do
  let(:root_name) { Faker::Internet.domain_word.capitalize }

  let(:permission0_name) { "#{root_name}xPermission" }
  let(:permission1_name) { "#{root_name}yPermission" }
  let(:permission2_name) { "#{root_name}zPermission" }

  let(:regulation0_name) { "#{root_name}xRegulation" }
  let(:regulation1_name) { "#{root_name}yRegulation" }
  let(:regulation2_name) { "#{root_name}zRegulation" }
end
