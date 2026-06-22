# frozen_string_literal: true

module StimulusSpec
  module Matchers
    class HaveStimulusController
      def initialize(name)
        @name = name.to_s
      end

      def matches?(subject)
        @body = extract_body(subject)
        !document.at_css("[data-controller~='#{@name}']").nil?
      end

      def does_not_match?(subject)
        !matches?(subject)
      end

      def failure_message
        "expected to find an element with data-controller=\"#{@name}\" but found none in:\n#{@body}"
      end

      def failure_message_when_negated
        "expected not to find an element with data-controller=\"#{@name}\" but found one"
      end

      def description
        "have Stimulus controller \"#{@name}\""
      end

      private

      def extract_body(subject)
        subject.respond_to?(:body) ? subject.body : subject.to_s
      end

      def document
        Nokogiri::HTML5.fragment(@body)
      end
    end

    def have_stimulus_controller(name)
      HaveStimulusController.new(name)
    end
  end
end
