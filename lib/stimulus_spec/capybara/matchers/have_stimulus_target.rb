# frozen_string_literal: true

module StimulusSpec
  module Capybara
    module Matchers
      # Capybara matcher for +data-{controller}-target+ attributes.
      #
      # @example
      #   expect(page).to have_stimulus_target("hello", "name")
      class HaveStimulusTarget
        # @param controller [String] controller name
        # @param target [String] target name
        def initialize(controller, target)
          @controller = controller.to_s
          @target = target.to_s
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

      # @param controller [String] controller name
      # @param target [String] target name
      # @return [HaveStimulusTarget]
      def have_stimulus_target(controller, target)
        HaveStimulusTarget.new(controller, target)
      end
    end
  end
end
