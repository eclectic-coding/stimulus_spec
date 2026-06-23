# frozen_string_literal: true

module StimulusSpec
  module Capybara
    module Matchers
      class HaveStimulusOutlet
        def initialize(controller, outlet, selector = nil)
          @controller = controller.to_s
          @outlet = outlet.to_s
          @selector = selector
          @attr = "data-#{@controller}-#{@outlet}-outlet"
        end

        def within(selector)
          @scope = selector
          self
        end

        def matches?(page)
          @page = page
          element = page.first(scoped_selector, minimum: 0, wait: 0)
          return false unless element

          if @selector
            @actual = element[@attr]
            @actual == @selector.to_s
          else
            true
          end
        end

        def does_not_match?(page)
          !matches?(page)
        end

        def failure_message
          if @selector && @actual
            "expected #{@attr} to be \"#{@selector}\" but was \"#{@actual}\""
          else
            "expected to find an element with #{@attr} on the page"
          end
        end

        def failure_message_when_negated
          "expected not to find an element with #{@attr} on the page"
        end

        def description
          if @selector
            "have Stimulus outlet \"#{@outlet}\" with \"#{@selector}\" for controller \"#{@controller}\""
          else
            "have Stimulus outlet \"#{@outlet}\" for controller \"#{@controller}\""
          end
        end

        private

        def scoped_selector
          base = "[#{@attr}]"
          @scope ? "#{@scope} #{base}" : base
        end
      end

      def have_stimulus_outlet(controller, outlet, selector = nil)
        HaveStimulusOutlet.new(controller, outlet, selector)
      end
    end
  end
end
