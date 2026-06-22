# frozen_string_literal: true

RSpec.describe StimulusSpec::Matchers::HaveStimulusOutlet do
  include StimulusSpec::Matchers

  describe "#matches?" do
    it "matches when outlet attribute exists (2-arg form)" do
      html = '<div data-search-results-outlet="#results-list"></div>'
      expect(html).to have_stimulus_outlet("search", "results")
    end

    it "does not match when outlet attribute is absent" do
      html = "<div></div>"
      expect(html).not_to have_stimulus_outlet("search", "results")
    end

    it "matches when selector equals expected (3-arg form)" do
      html = '<div data-search-results-outlet="#results-list"></div>'
      expect(html).to have_stimulus_outlet("search", "results", "#results-list")
    end

    it "does not match when selector differs from expected" do
      html = '<div data-search-results-outlet=".results"></div>'
      expect(html).not_to have_stimulus_outlet("search", "results", "#results-list")
    end

    it "works with hyphenated controller names" do
      html = '<div data-date-picker-calendar-outlet="#cal"></div>'
      expect(html).to have_stimulus_outlet("date-picker", "calendar", "#cal")
    end

    it "matches on nested elements" do
      html = '<section><div data-search-results-outlet="#results-list"></div></section>'
      expect(html).to have_stimulus_outlet("search", "results")
    end

    it "duck-types response objects with .body" do
      response = double(body: '<div data-search-results-outlet="#results-list"></div>')
      expect(response).to have_stimulus_outlet("search", "results")
    end
  end

  describe "#failure_message" do
    it "shows actual vs expected on selector mismatch" do
      html = '<div data-search-results-outlet=".results"></div>'
      matcher = have_stimulus_outlet("search", "results", "#results-list")
      matcher.matches?(html)
      expect(matcher.failure_message).to include("#results-list")
      expect(matcher.failure_message).to include(".results")
    end

    it "shows the HTML when attribute is missing" do
      html = "<div></div>"
      matcher = have_stimulus_outlet("search", "results")
      matcher.matches?(html)
      expect(matcher.failure_message).to include("data-search-results-outlet")
      expect(matcher.failure_message).to include("<div></div>")
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the attribute name" do
      html = '<div data-search-results-outlet="#results-list"></div>'
      matcher = have_stimulus_outlet("search", "results")
      matcher.matches?(html)
      expect(matcher.failure_message_when_negated).to include("data-search-results-outlet")
    end
  end

  describe "#description" do
    it "describes the 2-arg form" do
      matcher = have_stimulus_outlet("search", "results")
      expect(matcher.description).to eq('have Stimulus outlet "results" for controller "search"')
    end

    it "describes the 3-arg form" do
      matcher = have_stimulus_outlet("search", "results", "#results-list")
      expect(matcher.description).to eq('have Stimulus outlet "results" with "#results-list" for controller "search"')
    end
  end
end