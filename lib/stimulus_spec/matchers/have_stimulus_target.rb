# frozen_string_literal: true

module StimulusSpec
  module Matchers
    class HaveStimulusTarget
      def initialize(controller, target)
        @controller = controller.to_s
        @target = target.to_s
        @attr = "data-#{@controller}-target"
      end

      def matches?(subject)
        @body = extract_body(subject)
        @doc = Nokogiri::HTML5.fragment(@body)
        !@doc.at_css("[#{@attr}~='#{@target}']").nil?
      end

      def does_not_match?(subject)
        !matches?(subject)
      end

      def failure_message
        found_targets = @doc.css("[#{@attr}]").flat_map { |el| el[@attr].split }
        msg = "expected to find an element with #{@attr}=\"#{@target}\""
        msg += "\n  found targets: #{found_targets.uniq.map { |t| "\"#{t}\"" }.join(", ")}" if found_targets.any?
        msg += "\n  in:\n#{snippet}"
        msg
      end

      def failure_message_when_negated
        "expected not to find an element with #{@attr}=\"#{@target}\" but found one"
      end

      def description
        "have Stimulus target \"#{@target}\" for controller \"#{@controller}\""
      end

      private

      def extract_body(subject)
        subject.respond_to?(:body) ? subject.body : subject.to_s
      end

      def snippet
        elements = @doc.css("[#{@attr}]")
        return @body if elements.empty?

        elements.map(&:to_html).join("\n")
      end
    end

    def have_stimulus_target(controller, target)
      HaveStimulusTarget.new(controller, target)
    end
  end
end
