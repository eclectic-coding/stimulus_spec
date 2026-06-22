# frozen_string_literal: true

RSpec.describe StimulusSpec::Configuration do
  subject(:configuration) { described_class.new }

  describe "#auto_include" do
    it "defaults to true" do
      expect(configuration.auto_include).to be true
    end

    it "can be set to false" do
      configuration.auto_include = false
      expect(configuration.auto_include).to be false
    end
  end
end