# frozen_string_literal: true

module StimulusSpec
  module Matchers
    # Asserts that rendered HTML contains a +data-{controller}-{name}-value+ attribute.
    #
    # @example Existence check
    #   expect(response).to have_stimulus_value("search", "url")
    # @example Equality check
    #   expect(response).to have_stimulus_value("search", "url", "/results")
    class HaveStimulusValue
      # @param controller [String] controller name
      # @param name [String] value name
      # @param expected [String, nil] expected attribute value (omit for existence check)
      def initialize(controller, name, expected = nil)
        @controller = controller.to_s
        @name = name.to_s
        @expected = expected
        @attr = "data-#{@controller}-#{@name}-value"
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
          "have Stimulus value \"#{@name}\" with \"#{@expected}\" for controller \"#{@controller}\""
        else
          "have Stimulus value \"#{@name}\" for controller \"#{@controller}\""
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

    # @param controller [String] controller name
    # @param name [String] value name
    # @param expected [String, nil] expected value
    # @return [HaveStimulusValue]
    def have_stimulus_value(controller, name, expected = nil)
      HaveStimulusValue.new(controller, name, expected)
    end
  end
end
