# frozen_string_literal: true

module StimulusSpec
  module Matchers
    class HaveStimulusValue
      def initialize(controller, name, expected = nil)
        @controller = controller.to_s
        @name = name.to_s
        @expected = expected
        @attr = "data-#{@controller}-#{@name}-value"
      end

      def matches?(subject)
        @body = extract_body(subject)
        element = document.at_css("[#{@attr}]")
        return false unless element

        if @expected
          @actual = element[@attr]
          @actual == @expected.to_s
        else
          true
        end
      end

      def does_not_match?(subject)
        !matches?(subject)
      end

      def failure_message
        if @expected && @actual
          "expected #{@attr} to be \"#{@expected}\" but was \"#{@actual}\""
        else
          "expected to find an element with #{@attr} but found none in:\n#{@body}"
        end
      end

      def failure_message_when_negated
        "expected not to find an element with #{@attr} but found one"
      end

      def description
        if @expected
          "have Stimulus value \"#{@name}\" with \"#{@expected}\" for controller \"#{@controller}\""
        else
          "have Stimulus value \"#{@name}\" for controller \"#{@controller}\""
        end
      end

      private

      def extract_body(subject)
        subject.respond_to?(:body) ? subject.body : subject.to_s
      end

      def document
        Nokogiri::HTML5.fragment(@body)
      end
    end

    def have_stimulus_value(controller, name, expected = nil)
      HaveStimulusValue.new(controller, name, expected)
    end
  end
end
