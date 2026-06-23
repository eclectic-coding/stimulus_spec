# frozen_string_literal: true

module StimulusSpec
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

      def matches?(subject)
        @body = extract_body(subject)
        @doc = Nokogiri::HTML5.fragment(@body)
        @element = search_root&.at_css("[#{@attr}]")
        return false unless @element

        return true unless @selector

        @actual = @element[@attr]
        @actual == @selector.to_s
      end

      def does_not_match?(subject)
        !matches?(subject)
      end

      def failure_message
        if @selector && @actual
          "expected #{@attr} to be \"#{@selector}\" but was \"#{@actual}\"\n  on: #{@element.to_html}"
        else
          "expected to find an element with #{@attr} but found none in:\n#{snippet}"
        end
      end

      def failure_message_when_negated
        "expected not to find an element with #{@attr} but found one"
      end

      def description
        if @selector
          "have Stimulus outlet \"#{@outlet}\" with \"#{@selector}\" for controller \"#{@controller}\""
        else
          "have Stimulus outlet \"#{@outlet}\" for controller \"#{@controller}\""
        end
      end

      private

      def extract_body(subject)
        subject.respond_to?(:body) ? subject.body : subject.to_s
      end

      def search_root
        return @doc unless @scope

        @doc.at_css(@scope)
      end

      def snippet
        root = search_root || @doc
        elements = root.css("[data-controller]")
        return @body if elements.empty?

        elements.map(&:to_html).join("\n")
      end
    end

    def have_stimulus_outlet(controller, outlet, selector = nil)
      HaveStimulusOutlet.new(controller, outlet, selector)
    end
  end
end
