# frozen_string_literal: true

module StimulusSpec
  module Capybara
    module Matchers
      class HaveStimulusTarget
        def initialize(controller, target)
          @controller = controller.to_s
          @target = target.to_s
        end

        def within(selector)
          @scope = selector
          self
        end

        def matches?(page)
          @page = page
          page.has_css?(scoped_selector, wait: 0)
        end

        def does_not_match?(page)
          page.has_no_css?(scoped_selector, wait: 0)
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

        private

        def scoped_selector
          base = "[data-#{@controller}-target~='#{@target}']"
          @scope ? "#{@scope} #{base}" : base
        end
      end

      def have_stimulus_target(controller, target)
        HaveStimulusTarget.new(controller, target)
      end
    end
  end
end
