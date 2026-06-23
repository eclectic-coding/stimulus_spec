# frozen_string_literal: true

module StimulusSpec
  # Controls auto-include behavior for RSpec integration.
  class Configuration
    # @return [Boolean] whether matchers are auto-included into RSpec groups (default: +true+)
    attr_accessor :auto_include

    def initialize
      @auto_include = true
    end
  end
end
