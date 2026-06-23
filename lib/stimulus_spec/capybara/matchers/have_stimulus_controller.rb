# frozen_string_literal: true

module StimulusSpec
  module Capybara
    module Matchers
      # Capybara matcher for +data-controller+ attributes.
      #
      # @example
      #   expect(page).to have_stimulus_controller("hello")
      # @example Multiple controllers
      #   expect(page).to have_stimulus_controller("hello", "clipboard")
      class HaveStimulusController
        # @param names [Array<String>] one or more controller names
        def initialize(*names)
          @names = names.map(&:to_s)
        end

        # @param selector [String] CSS selector for the scope element
        # @return [self]
        def within(selector)
          @scope = selector
          self
        end

        # @param page [Capybara::Session, Capybara::Node::Simple] Capybara page object
        # @return [Boolean]
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

      # @param names [Array<String>] one or more controller names
      # @return [HaveStimulusController]
      def have_stimulus_controller(*names)
        HaveStimulusController.new(*names)
      end
    end
  end
end
