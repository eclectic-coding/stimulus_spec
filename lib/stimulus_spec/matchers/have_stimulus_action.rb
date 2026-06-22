# frozen_string_literal: true

module StimulusSpec
  module Matchers
    class HaveStimulusAction
      def initialize(descriptor)
        @descriptor = descriptor.to_s
      end

      def matches?(subject)
        @body = extract_body(subject)
        if @descriptor.include?("->")
          !document.at_css("[data-action~='#{@descriptor}']").nil?
        else
          !document.at_css("[data-action*='#{@descriptor}']").nil?
        end
      end

      def does_not_match?(subject)
        !matches?(subject)
      end

      def failure_message
        "expected to find an element with data-action=\"#{@descriptor}\" but found none in:\n#{@body}"
      end

      def failure_message_when_negated
        "expected not to find an element with data-action=\"#{@descriptor}\" but found one"
      end

      def description
        "have Stimulus action \"#{@descriptor}\""
      end

      private

      def extract_body(subject)
        subject.respond_to?(:body) ? subject.body : subject.to_s
      end

      def document
        Nokogiri::HTML5.fragment(@body)
      end
    end

    def have_stimulus_action(descriptor)
      HaveStimulusAction.new(descriptor)
    end
  end
end
