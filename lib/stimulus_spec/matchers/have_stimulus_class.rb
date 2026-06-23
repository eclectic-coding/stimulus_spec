# frozen_string_literal: true

module StimulusSpec
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

      def matches?(subject)
        @body = extract_body(subject)
        @doc = Nokogiri::HTML5.fragment(@body)
        @element = search_root&.at_css("[#{@attr}]")
        return false unless @element

        return true unless @expected

        @actual = @element[@attr]
        @actual == @expected.to_s
      end

      def does_not_match?(subject)
        !matches?(subject)
      end

      def failure_message
        if @expected && @actual
          "expected #{@attr} to be \"#{@expected}\" but was \"#{@actual}\"\n  on: #{@element.to_html}"
        else
          "expected to find an element with #{@attr} but found none in:\n#{snippet}"
        end
      end

      def failure_message_when_negated
        "expected not to find an element with #{@attr} but found one"
      end

      def description
        if @expected
          "have Stimulus class \"#{@name}\" with \"#{@expected}\" for controller \"#{@controller}\""
        else
          "have Stimulus class \"#{@name}\" for controller \"#{@controller}\""
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

    def have_stimulus_class(controller, name, expected = nil)
      HaveStimulusClass.new(controller, name, expected)
    end
  end
end
