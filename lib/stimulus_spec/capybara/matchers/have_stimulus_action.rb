# frozen_string_literal: true

module StimulusSpec
  module Capybara
    module Matchers
      class HaveStimulusAction
        def initialize(descriptor)
          @descriptor = descriptor.to_s
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

      def have_stimulus_action(descriptor)
        HaveStimulusAction.new(descriptor)
      end
    end
  end
end
