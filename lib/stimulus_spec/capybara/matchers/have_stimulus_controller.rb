# frozen_string_literal: true

module StimulusSpec
  module Capybara
    module Matchers
      class HaveStimulusController
        def initialize(*names)
          @names = names.map(&:to_s)
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
          "expected to find an element with data-controller=#{label} on the page"
        end

        def failure_message_when_negated
          "expected not to find an element with data-controller=#{label} on the page"
        end

        def description
          "have Stimulus controller #{label}"
        end

        private

        def label
          @names.map { |n| "\"#{n}\"" }.join(", ")
        end

        def scoped_selector
          selector = @names.map { |n| "[data-controller~='#{n}']" }.join
          @scope ? "#{@scope} #{selector}" : selector
        end
      end

      def have_stimulus_controller(*names)
        HaveStimulusController.new(*names)
      end
    end
  end
end
