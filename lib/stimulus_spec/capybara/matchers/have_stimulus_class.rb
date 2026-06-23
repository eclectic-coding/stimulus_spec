# frozen_string_literal: true

module StimulusSpec
  module Capybara
    module Matchers
      class HaveStimulusClass
        def initialize(controller, name, expected = nil)
          @controller = controller.to_s
          @name = name.to_s
          @expected = expected
          @attr = "data-#{@controller}-#{@name}-class"
        end

        def within(selector)
          @scope = selector
          self
        end

        def matches?(page)
          @page = page
          element = page.first(scoped_selector, minimum: 0, wait: 0)
          return false unless element

          if @expected
            @actual = element[@attr]
            @actual == @expected.to_s
          else
            true
          end
        end

        def does_not_match?(page)
          !matches?(page)
        end

        def failure_message
          if @expected && @actual
            "expected #{@attr} to be \"#{@expected}\" but was \"#{@actual}\""
          else
            "expected to find an element with #{@attr} on the page"
          end
        end

        def failure_message_when_negated
          "expected not to find an element with #{@attr} on the page"
        end

        def description
          if @expected
            "have Stimulus class \"#{@name}\" with \"#{@expected}\" for controller \"#{@controller}\""
          else
            "have Stimulus class \"#{@name}\" for controller \"#{@controller}\""
          end
        end

        private

        def scoped_selector
          base = "[#{@attr}]"
          @scope ? "#{@scope} #{base}" : base
        end
      end

      def have_stimulus_class(controller, name, expected = nil)
        HaveStimulusClass.new(controller, name, expected)
      end
    end
  end
end
