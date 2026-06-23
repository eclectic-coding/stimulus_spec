# frozen_string_literal: true

module StimulusSpec
  module Matchers
    class HaveStimulusAction
      def initialize(descriptor)
        @descriptor = descriptor.to_s
      end

      def within(selector)
        @scope = selector
        self
      end

      def matches?(subject)
        @body = extract_body(subject)
        @doc = Nokogiri::HTML5.fragment(@body)
        root = search_root
        return false unless root

        if @descriptor.include?("->")
          !root.at_css("[data-action~='#{@descriptor}']").nil?
        else
          !root.at_css("[data-action*='#{@descriptor}']").nil?
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

      def search_root
        return @doc unless @scope

        @doc.at_css(@scope)
      end

      def snippet
        root = search_root || @doc
        elements = root.css("[data-action]")
        return @body if elements.empty?

        elements.map(&:to_html).join("\n")
      end
    end

    def have_stimulus_action(descriptor)
      HaveStimulusAction.new(descriptor)
    end
  end
end
