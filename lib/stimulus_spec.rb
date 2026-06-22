# frozen_string_literal: true

require_relative "stimulus_spec/version"
require_relative "stimulus_spec/configuration"
require_relative "stimulus_spec/matchers"
require_relative "stimulus_spec/capybara/matchers"

module StimulusSpec
  class Error < StandardError; end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.reset_configuration!
    @configuration = Configuration.new
  end

  def self.install_rspec_integration(config)
    return unless Gem.loaded_specs.key?("stimulus-rails")
    return unless configuration.auto_include

    %i[request controller].each do |type|
      config.include StimulusSpec::Matchers, type: type
    end

    return unless Gem.loaded_specs.key?("capybara")

    %i[system feature].each do |type|
      config.include StimulusSpec::Capybara::Matchers, type: type
    end
  end
end

# :nocov:
if defined?(RSpec)
  RSpec.configure do |config|
    StimulusSpec.install_rspec_integration(config)
  end
end
# :nocov:
