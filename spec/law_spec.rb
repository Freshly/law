# frozen_string_literal: true

RSpec.describe Law do
  it "has a version number" do
    expect(Law::VERSION).not_to be_nil
  end
end
