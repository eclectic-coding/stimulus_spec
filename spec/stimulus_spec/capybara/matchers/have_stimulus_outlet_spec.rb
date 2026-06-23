# frozen_string_literal: true

require "capybara"

RSpec.describe StimulusSpec::Capybara::Matchers::HaveStimulusOutlet do
  include StimulusSpec::Capybara::Matchers

  describe "#matches?" do
    it "matches when outlet attribute exists (2-arg form)" do
      page = ::Capybara.string('<div data-search-results-outlet="#results-list"></div>')
      expect(page).to have_stimulus_outlet("search", "results")
    end

    it "does not match when outlet attribute is absent" do
      page = ::Capybara.string("<div></div>")
      expect(page).not_to have_stimulus_outlet("search", "results")
    end

    it "matches when selector equals expected (3-arg form)" do
      page = ::Capybara.string('<div data-search-results-outlet="#results-list"></div>')
      expect(page).to have_stimulus_outlet("search", "results", "#results-list")
    end

    it "does not match when selector differs from expected" do
      page = ::Capybara.string('<div data-search-results-outlet=".results"></div>')
      expect(page).not_to have_stimulus_outlet("search", "results", "#results-list")
    end

    it "works with hyphenated controller names" do
      page = ::Capybara.string('<div data-date-picker-calendar-outlet="#cal"></div>')
      expect(page).to have_stimulus_outlet("date-picker", "calendar", "#cal")
    end
  end

  describe "#does_not_match?" do
    it "returns true when attribute is absent" do
      page = ::Capybara.string("<div></div>")
      matcher = have_stimulus_outlet("search", "results")
      expect(matcher.does_not_match?(page)).to be true
    end
  end

  describe "#failure_message" do
    it "shows actual vs expected on selector mismatch" do
      page = ::Capybara.string('<div data-search-results-outlet=".results"></div>')
      matcher = have_stimulus_outlet("search", "results", "#results-list")
      matcher.matches?(page)
      expect(matcher.failure_message).to include("#results-list")
      expect(matcher.failure_message).to include(".results")
    end

    it "includes the attribute name when missing" do
      page = ::Capybara.string("<div></div>")
      matcher = have_stimulus_outlet("search", "results")
      matcher.matches?(page)
      expect(matcher.failure_message).to include("data-search-results-outlet")
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the attribute name" do
      page = ::Capybara.string('<div data-search-results-outlet="#results-list"></div>')
      matcher = have_stimulus_outlet("search", "results")
      matcher.matches?(page)
      expect(matcher.failure_message_when_negated).to include("data-search-results-outlet")
    end
  end

  describe "#within" do
    it "matches within the given selector" do
      page = ::Capybara.string('<form class="search"><div data-search-results-outlet="#results-list"></div></form>')
      expect(page).to have_stimulus_outlet("search", "results").within(".search")
    end

    it "does not match outside the given selector" do
      page = ::Capybara.string('<div data-search-results-outlet="#results-list"></div><form class="search"></form>')
      expect(page).not_to have_stimulus_outlet("search", "results").within(".search")
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