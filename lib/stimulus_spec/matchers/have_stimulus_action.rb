# frozen_string_literal: true

module StimulusSpec
  module Matchers
    class HaveStimulusAction
      def initialize(descriptor)
        @descriptor = descriptor.to_s
      end

      def matches?(subject)
        @body = extract_body(subject)
        @doc = Nokogiri::HTML5.fragment(@body)
        if @descriptor.include?("->")
          !@doc.at_css("[data-action~='#{@descriptor}']").nil?
        else
          !@doc.at_css("[data-action*='#{@descriptor}']").nil?
        end
      end

      def does_not_match?(subject)
        !matches?(subject)
      end

      def failure_message
        found_actions = @doc.css("[data-action]").flat_map { |el| el["data-action"].split }
        msg = "expected to find an element with data-action=\"#{@descriptor}\""
        msg += "\n  found actions: #{found_actions.uniq.map { |a| "\"#{a}\"" }.join(", ")}" if found_actions.any?
        msg += "\n  in:\n#{snippet}"
        msg
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

      def snippet
        elements = @doc.css("[data-action]")
        return @body if elements.empty?

        elements.map(&:to_html).join("\n")
      end
    end

    def have_stimulus_action(descriptor)
      HaveStimulusAction.new(descriptor)
    end
  end
end
