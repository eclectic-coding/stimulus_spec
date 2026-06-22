# frozen_string_literal: true

module StimulusSpec
  module Capybara
    module Matchers
      class HaveStimulusTarget
        def initialize(controller, target)
          @controller = controller.to_s
          @target = target.to_s
        end

        def matches?(page)
          @page = page
          page.has_css?("[data-#{@controller}-target~='#{@target}']", wait: 0)
        end

        def does_not_match?(page)
          page.has_no_css?("[data-#{@controller}-target~='#{@target}']", wait: 0)
        end

        def failure_message
          "expected to find an element with data-#{@controller}-target=\"#{@target}\" on the page"
        end

        def failure_message_when_negated
          "expected not to find an element with data-#{@controller}-target=\"#{@target}\" on the page"
        end

        def description
          "have Stimulus target \"#{@target}\" for controller \"#{@controller}\""
        end
      end

      def have_stimulus_target(controller, target)
        HaveStimulusTarget.new(controller, target)
      end
    end
  end
end
