# frozen_string_literal: true

require_relative "stimulus_spec/version"
require_relative "stimulus_spec/configuration"
require_relative "stimulus_spec/matchers"
require_relative "stimulus_spec/capybara/matchers"

# RSpec matchers for testing Stimulus controller wiring in Rails applications.
#
# Provides matchers for asserting +data-controller+, +data-action+,
# +data-*-target+, +data-*-*-value+, +data-*-*-class+, and
# +data-*-*-outlet+ attributes in rendered HTML and Capybara pages.
#
# @example Auto-included in Rails with stimulus-rails
#   RSpec.describe "Search", type: :request do
#     it "wires up the controller" do
#       get search_path
#       expect(response).to have_stimulus_controller("search")
#     end
#   end
module StimulusSpec
  class Error < StandardError; end

  # @return [Configuration] the current configuration instance
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Yields the configuration for modification.
  #
  # @yieldparam config [Configuration]
  # @return [void]
  def self.configure
    yield configuration
  end

  # Replaces the current configuration with a fresh instance.
  #
  # @return [Configuration] the new configuration
  def self.reset_configuration!
    @configuration = Configuration.new
  end

  # Includes matchers into RSpec example groups when stimulus-rails is present.
  #
  # @param config [RSpec::Core::Configuration]
  # @return [void]
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
