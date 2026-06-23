# frozen_string_literal: true

module StimulusSpec
  module Matchers
    # Asserts that rendered HTML contains a +data-{controller}-target+ attribute with the given target name.
    #
    # @example
    #   expect(response).to have_stimulus_target("hello", "name")
    class HaveStimulusTarget
      # @param controller [String] controller name
      # @param target [String] target name
      def initialize(controller, target)
        @controller = controller.to_s
        @target = target.to_s
        @attr = "data-#{@controller}-target"
      end

      # @param selector [String] CSS selector for the scope element
      # @return [self]
      def within(selector)
        @scope = selector
        self
      end

      # @param subject [#body, String] response object or HTML string
      # @return [Boolean]
      def matches?(subject)
        @body = extract_body(subject)
        @doc = Nokogiri::HTML5.fragment(@body)
        root = search_root
        return false unless root

        !root.at_css("[#{@attr}~='#{@target}']").nil?
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

      def search_root
        return @doc unless @scope

        @doc.at_css(@scope)
      end

      def snippet
        root = search_root || @doc
        elements = root.css("[#{@attr}]")
        return @body if elements.empty?

        elements.map(&:to_html).join("\n")
      end
    end

    # @param controller [String] controller name
    # @param target [String] target name
    # @return [HaveStimulusTarget]
    def have_stimulus_target(controller, target)
      HaveStimulusTarget.new(controller, target)
    end
  end
end
