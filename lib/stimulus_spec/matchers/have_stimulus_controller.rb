# frozen_string_literal: true

module StimulusSpec
  # Matchers for request and controller specs (Nokogiri-based HTML parsing).
  module Matchers
    # Asserts that rendered HTML contains a +data-controller+ attribute with the given name(s).
    #
    # @example Single controller
    #   expect(response).to have_stimulus_controller("hello")
    # @example Multiple controllers on one element
    #   expect(response).to have_stimulus_controller("hello", "clipboard")
    # @example Scoped
    #   expect(response).to have_stimulus_controller("search").within(".search-form")
    class HaveStimulusController
      # @param names [Array<String>] one or more controller names to match
      def initialize(*names)
        @names = names.map(&:to_s)
      end

      # Restricts matching to descendants of the given CSS selector.
      #
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

        @found_controllers = root.css("[data-controller]").flat_map { |el| el["data-controller"].split }
        selector = @names.map { |n| "[data-controller~='#{n}']" }.join
        !root.at_css(selector).nil?
      end

      def does_not_match?(subject)
        !matches?(subject)
      end

      def failure_message
        label = @names.map { |n| "\"#{n}\"" }.join(", ")
        msg = "expected to find an element with data-controller=#{label}"
        if @found_controllers&.any?
          msg += "\n  found controllers: #{@found_controllers.uniq.map { |c| "\"#{c}\"" }.join(", ")}"
        end
        msg += "\n  in:\n#{snippet}"
        msg
      end

      def failure_message_when_negated
        label = @names.map { |n| "\"#{n}\"" }.join(", ")
        "expected not to find an element with data-controller=#{label} but found one"
      end

      def description
        label = @names.map { |n| "\"#{n}\"" }.join(", ")
        "have Stimulus controller #{label}"
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

    # @param names [Array<String>] one or more controller names
    # @return [HaveStimulusController]
    def have_stimulus_controller(*names)
      HaveStimulusController.new(*names)
    end
  end
end
