# frozen_string_literal: true

module StimulusSpec
  module Matchers
    class HaveStimulusTarget
      def initialize(controller, target)
        @controller = controller.to_s
        @target = target.to_s
      end

      def matches?(subject)
        @body = extract_body(subject)
        !document.at_css("[data-#{@controller}-target~='#{@target}']").nil?
      end

      def does_not_match?(subject)
        !matches?(subject)
      end

      def failure_message
        "expected to find an element with data-#{@controller}-target=\"#{@target}\" but found none in:\n#{@body}"
      end

      def failure_message_when_negated
        "expected not to find an element with data-#{@controller}-target=\"#{@target}\" but found one"
      end

      def description
        "have Stimulus target \"#{@target}\" for controller \"#{@controller}\""
      end

      private

      def extract_body(subject)
        subject.respond_to?(:body) ? subject.body : subject.to_s
      end

      def document
        Nokogiri::HTML5.fragment(@body)
      end
    end

    def have_stimulus_target(controller, target)
      HaveStimulusTarget.new(controller, target)
    end
  end
end
