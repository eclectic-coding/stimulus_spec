# frozen_string_literal: true

RSpec.describe StimulusSpec do
  after { described_class.reset_configuration! }

  describe ".configuration" do
    it "returns a Configuration instance" do
      expect(described_class.configuration).to be_a(StimulusSpec::Configuration)
    end

    it "memoizes the instance" do
      expect(described_class.configuration).to be(described_class.configuration)
    end
  end

  describe ".configure" do
    it "yields the configuration" do
      described_class.configure do |config|
        expect(config).to be(described_class.configuration)
      end
    end

    it "allows setting auto_include" do
      described_class.configure { |c| c.auto_include = false }
      expect(described_class.configuration.auto_include).to be false
    end
  end

  describe ".reset_configuration!" do
    it "replaces the configuration with a fresh instance" do
      original = described_class.configuration
      described_class.reset_configuration!
      expect(described_class.configuration).not_to be(original)
    end

    it "restores defaults" do
      described_class.configure { |c| c.auto_include = false }
      described_class.reset_configuration!
      expect(described_class.configuration.auto_include).to be true
    end
  end

  describe ".install_rspec_integration" do
    let(:rspec_config) { instance_double(RSpec::Core::Configuration) }

    context "when stimulus-rails is loaded and auto_include is true" do
      before do
        allow(Gem).to receive(:loaded_specs).and_return("stimulus-rails" => true)
      end

      it "includes Matchers into request, controller, system, and feature groups" do
        %i[request controller system feature].each do |type|
          expect(rspec_config).to receive(:include).with(StimulusSpec::Matchers, type: type)
        end

        described_class.install_rspec_integration(rspec_config)
      end
    end

    context "when stimulus-rails is not loaded" do
      before do
        allow(Gem).to receive(:loaded_specs).and_return({})
      end

      it "does not include Matchers" do
        expect(rspec_config).not_to receive(:include)
        described_class.install_rspec_integration(rspec_config)
      end
    end

    context "when auto_include is false" do
      before do
        allow(Gem).to receive(:loaded_specs).and_return("stimulus-rails" => true)
        described_class.configure { |c| c.auto_include = false }
      end

      it "does not include Matchers" do
        expect(rspec_config).not_to receive(:include)
        described_class.install_rspec_integration(rspec_config)
      end
    end
  end
end