# frozen_string_literal: true

module StimulusSpec
  module Capybara
    module Matchers
      class HaveStimulusController
        def initialize(name)
          @name = name.to_s
        end

        def matches?(page)
          @page = page
          page.has_css?("[data-controller~='#{@name}']", wait: 0)
        end

        def does_not_match?(page)
          page.has_no_css?("[data-controller~='#{@name}']", wait: 0)
        end

        def failure_message
          "expected to find an element with data-controller=\"#{@name}\" on the page"
        end

        def failure_message_when_negated
          "expected not to find an element with data-controller=\"#{@name}\" on the page"
        end

        def description
          "have Stimulus controller \"#{@name}\""
        end
      end

      def have_stimulus_controller(name)
        HaveStimulusController.new(name)
      end
    end
  end
end
