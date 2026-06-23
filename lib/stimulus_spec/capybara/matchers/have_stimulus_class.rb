# frozen_string_literal: true

module StimulusSpec
  module Capybara
    module Matchers
      # Capybara matcher for +data-{controller}-{name}-class+ attributes.
      #
      # @example
      #   expect(page).to have_stimulus_class("search", "loading", "opacity-50")
      class HaveStimulusClass
        # @param controller [String] controller name
        # @param name [String] class name
        # @param expected [String, nil] expected attribute value
        def initialize(controller, name, expected = nil)
          @controller = controller.to_s
          @name = name.to_s
          @expected = expected
          @attr = "data-#{@controller}-#{@name}-class"
        end

        # @param selector [String] CSS selector for the scope element
        # @return [self]
        def within(selector)
          @scope = selector
          self
        end

        # @param page [Capybara::Session, Capybara::Node::Simple]
        # @return [Boolean]
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

      # @param controller [String] controller name
      # @param name [String] class name
      # @param expected [String, nil] expected class value
      # @return [HaveStimulusClass]
      def have_stimulus_class(controller, name, expected = nil)
        HaveStimulusClass.new(controller, name, expected)
      end
    end
  end
end
