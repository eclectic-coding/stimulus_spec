# frozen_string_literal: true

RSpec.describe "StimulusSpec::VERSION" do
  it "is a semver string" do
    expect(StimulusSpec::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end
end
