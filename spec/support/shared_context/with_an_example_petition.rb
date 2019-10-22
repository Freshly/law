# frozen_string_literal: true

RSpec.shared_context "with an example petition" do
  include_context "with laws and regulations"
  include_context "with roles and permissions"

  subject(:example_petition) do
    Law::Petition.new(law: law, source: source, roles: roles, target: target, params: params)
  end

  let(:law) { law0 }
  let(:source) { nil }
  let(:roles) { [] }
  let(:target) { nil }
  let(:params) { {} }
end
