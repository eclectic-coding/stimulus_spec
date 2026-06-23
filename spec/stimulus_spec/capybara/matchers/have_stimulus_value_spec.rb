# frozen_string_literal: true

require "capybara"

RSpec.describe StimulusSpec::Capybara::Matchers::HaveStimulusValue do
  include StimulusSpec::Capybara::Matchers

  describe "#matches?" do
    it "matches when value attribute exists (2-arg form)" do
      page = ::Capybara.string('<div data-search-url-value="/results"></div>')
      expect(page).to have_stimulus_value("search", "url")
    end

    it "does not match when value attribute is absent" do
      page = ::Capybara.string("<div></div>")
      expect(page).not_to have_stimulus_value("search", "url")
    end

    it "matches when value equals expected (3-arg form)" do
      page = ::Capybara.string('<div data-search-url-value="/results"></div>')
      expect(page).to have_stimulus_value("search", "url", "/results")
    end

    it "does not match when value differs from expected" do
      page = ::Capybara.string('<div data-search-url-value="/api/search"></div>')
      expect(page).not_to have_stimulus_value("search", "url", "/results")
    end

    it "works with hyphenated controller names" do
      page = ::Capybara.string('<div data-date-picker-url-value="/dates"></div>')
      expect(page).to have_stimulus_value("date-picker", "url", "/dates")
    end
  end

  describe "#does_not_match?" do
    it "uses has_no_css? for negation" do
      page = ::Capybara.string("<div></div>")
      matcher = have_stimulus_value("search", "url")
      expect(matcher.does_not_match?(page)).to be true
    end
  end

  describe "#failure_message" do
    it "shows actual vs expected on value mismatch" do
      page = ::Capybara.string('<div data-search-url-value="/api/search"></div>')
      matcher = have_stimulus_value("search", "url", "/results")
      matcher.matches?(page)
      expect(matcher.failure_message).to include("/results")
      expect(matcher.failure_message).to include("/api/search")
    end

    it "includes the attribute name when missing" do
      page = ::Capybara.string("<div></div>")
      matcher = have_stimulus_value("search", "url")
      matcher.matches?(page)
      expect(matcher.failure_message).to include("data-search-url-value")
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the attribute name" do
      page = ::Capybara.string('<div data-search-url-value="/results"></div>')
      matcher = have_stimulus_value("search", "url")
      matcher.matches?(page)
      expect(matcher.failure_message_when_negated).to include("data-search-url-value")
    end
  end

  describe "#within" do
    it "matches within the given selector" do
      page = ::Capybara.string('<form class="search"><div data-search-url-value="/results"></div></form>')
      expect(page).to have_stimulus_value("search", "url").within(".search")
    end

    it "does not match outside the given selector" do
      page = ::Capybara.string('<div data-search-url-value="/results"></div><form class="search"></form>')
      expect(page).not_to have_stimulus_value("search", "url").within(".search")
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