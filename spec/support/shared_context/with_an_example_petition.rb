# frozen_string_literal: true

RSpec.shared_context "with an example petition" do
  include_context "with statutes and regulations"
  include_context "with roles and permissions"

  subject(:example_petition) do
    Law::Petition.new(statute: statute, source: source, permissions: permissions, target: target, params: params)
  end

  let(:statute) { statute0 }
  let(:source) { nil }
  let(:permissions) { [] }
  let(:target) { nil }
  let(:params) { {} }
end
