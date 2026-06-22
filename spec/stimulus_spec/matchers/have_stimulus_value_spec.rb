# frozen_string_literal: true

RSpec.describe StimulusSpec::Matchers::HaveStimulusValue do
  include StimulusSpec::Matchers

  describe "#matches?" do
    it "matches when value attribute exists (2-arg form)" do
      html = '<div data-search-url-value="/results"></div>'
      expect(html).to have_stimulus_value("search", "url")
    end

    it "does not match when value attribute is absent" do
      html = "<div></div>"
      expect(html).not_to have_stimulus_value("search", "url")
    end

    it "matches when value equals expected (3-arg form)" do
      html = '<div data-search-url-value="/results"></div>'
      expect(html).to have_stimulus_value("search", "url", "/results")
    end

    it "does not match when value differs from expected" do
      html = '<div data-search-url-value="/api/search"></div>'
      expect(html).not_to have_stimulus_value("search", "url", "/results")
    end

    it "works with hyphenated controller names" do
      html = '<div data-date-picker-url-value="/dates"></div>'
      expect(html).to have_stimulus_value("date-picker", "url", "/dates")
    end

    it "matches on nested elements" do
      html = '<section><input data-search-url-value="/results"></section>'
      expect(html).to have_stimulus_value("search", "url")
    end

    it "duck-types response objects with .body" do
      response = double(body: '<div data-search-url-value="/results"></div>')
      expect(response).to have_stimulus_value("search", "url")
    end
  end

  describe "#failure_message" do
    it "shows actual vs expected on value mismatch with element HTML" do
      html = '<div data-search-url-value="/api/search"></div>'
      matcher = have_stimulus_value("search", "url", "/results")
      matcher.matches?(html)
      expect(matcher.failure_message).to include("/results")
      expect(matcher.failure_message).to include("/api/search")
      expect(matcher.failure_message).to include("on:")
    end

    it "shows the HTML when attribute is missing" do
      html = "<div></div>"
      matcher = have_stimulus_value("search", "url")
      matcher.matches?(html)
      expect(matcher.failure_message).to include("data-search-url-value")
      expect(matcher.failure_message).to include("<div></div>")
    end

    it "shows relevant controller elements when attribute is missing" do
      html = '<div data-controller="search"></div>'
      matcher = have_stimulus_value("search", "url")
      matcher.matches?(html)
      expect(matcher.failure_message).to include("data-controller")
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the attribute name" do
      html = '<div data-search-url-value="/results"></div>'
      matcher = have_stimulus_value("search", "url")
      matcher.matches?(html)
      expect(matcher.failure_message_when_negated).to include("data-search-url-value")
    end
  end

  describe "#description" do
    it "describes the 2-arg form" do
      matcher = have_stimulus_value("search", "url")
      expect(matcher.description).to eq('have Stimulus value "url" for controller "search"')
    end

    it "describes the 3-arg form" do
      matcher = have_stimulus_value("search", "url", "/results")
      expect(matcher.description).to eq('have Stimulus value "url" with "/results" for controller "search"')
    end
  end
end