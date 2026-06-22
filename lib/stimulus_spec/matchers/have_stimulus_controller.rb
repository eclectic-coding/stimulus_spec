# frozen_string_literal: true

module StimulusSpec
  module Matchers
    class HaveStimulusController
      def initialize(name)
        @name = name.to_s
      end

      def matches?(subject)
        @body = extract_body(subject)
        @doc = Nokogiri::HTML5.fragment(@body)
        @found_controllers = @doc.css("[data-controller]").flat_map { |el| el["data-controller"].split }
        !@doc.at_css("[data-controller~='#{@name}']").nil?
      end

      def does_not_match?(subject)
        !matches?(subject)
      end

      def failure_message
        msg = "expected to find an element with data-controller=\"#{@name}\""
        if @found_controllers.any?
          msg += "\n  found controllers: #{@found_controllers.uniq.map { |c| "\"#{c}\"" }.join(", ")}"
        end
        msg += "\n  in:\n#{snippet}"
        msg
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

      def snippet
        elements = @doc.css("[data-controller]")
        return @body if elements.empty?

        elements.map(&:to_html).join("\n")
      end
    end

    def have_stimulus_controller(name)
      HaveStimulusController.new(name)
    end
  end
end
