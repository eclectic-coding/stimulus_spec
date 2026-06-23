# frozen_string_literal: true

module StimulusSpec
  module Capybara
    module Matchers
      # Capybara matcher for +data-action+ attributes.
      #
      # @example
      #   expect(page).to have_stimulus_action("click->hello#greet")
      class HaveStimulusAction
        # @param descriptor [String] action descriptor
        def initialize(descriptor)
          @descriptor = descriptor.to_s
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
          "expected to find an element with data-action=\"#{@descriptor}\" on the page"
        end

        def failure_message_when_negated
          "expected not to find an element with data-action=\"#{@descriptor}\" on the page"
        end

        def description
          "have Stimulus action \"#{@descriptor}\""
        end

        private

        def scoped_selector
          base = if @descriptor.include?("->")
                   "[data-action~='#{@descriptor}']"
                 else
                   "[data-action*='#{@descriptor}']"
                 end
          @scope ? "#{@scope} #{base}" : base
        end
      end

      # @param descriptor [String] action descriptor
      # @return [HaveStimulusAction]
      def have_stimulus_action(descriptor)
        HaveStimulusAction.new(descriptor)
      end
    end
  end
end
