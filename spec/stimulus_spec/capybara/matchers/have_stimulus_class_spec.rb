# frozen_string_literal: true

require "capybara"

RSpec.describe StimulusSpec::Capybara::Matchers::HaveStimulusClass do
  include StimulusSpec::Capybara::Matchers

  describe "#matches?" do
    it "matches when class attribute exists (2-arg form)" do
      page = ::Capybara.string('<div data-search-loading-class="opacity-50"></div>')
      expect(page).to have_stimulus_class("search", "loading")
    end

    it "does not match when class attribute is absent" do
      page = ::Capybara.string("<div></div>")
      expect(page).not_to have_stimulus_class("search", "loading")
    end

    it "matches when class equals expected (3-arg form)" do
      page = ::Capybara.string('<div data-search-loading-class="opacity-50"></div>')
      expect(page).to have_stimulus_class("search", "loading", "opacity-50")
    end

    it "does not match when class differs from expected" do
      page = ::Capybara.string('<div data-search-loading-class="hidden"></div>')
      expect(page).not_to have_stimulus_class("search", "loading", "opacity-50")
    end

    it "works with hyphenated controller names" do
      page = ::Capybara.string('<div data-date-picker-active-class="bg-blue"></div>')
      expect(page).to have_stimulus_class("date-picker", "active", "bg-blue")
    end
  end

  describe "#does_not_match?" do
    it "returns true when attribute is absent" do
      page = ::Capybara.string("<div></div>")
      matcher = have_stimulus_class("search", "loading")
      expect(matcher.does_not_match?(page)).to be true
    end
  end

  describe "#failure_message" do
    it "shows actual vs expected on class mismatch" do
      page = ::Capybara.string('<div data-search-loading-class="hidden"></div>')
      matcher = have_stimulus_class("search", "loading", "opacity-50")
      matcher.matches?(page)
      expect(matcher.failure_message).to include("opacity-50")
      expect(matcher.failure_message).to include("hidden")
    end

    it "includes the attribute name when missing" do
      page = ::Capybara.string("<div></div>")
      matcher = have_stimulus_class("search", "loading")
      matcher.matches?(page)
      expect(matcher.failure_message).to include("data-search-loading-class")
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the attribute name" do
      page = ::Capybara.string('<div data-search-loading-class="opacity-50"></div>')
      matcher = have_stimulus_class("search", "loading")
      matcher.matches?(page)
      expect(matcher.failure_message_when_negated).to include("data-search-loading-class")
    end
  end

  describe "#within" do
    it "matches within the given selector" do
      page = ::Capybara.string('<form class="search"><div data-search-loading-class="opacity-50"></div></form>')
      expect(page).to have_stimulus_class("search", "loading").within(".search")
    end

    it "does not match outside the given selector" do
      page = ::Capybara.string('<div data-search-loading-class="opacity-50"></div><form class="search"></form>')
      expect(page).not_to have_stimulus_class("search", "loading").within(".search")
    end
  end

  describe "#description" do
    it "describes the 2-arg form" do
      matcher = have_stimulus_class("search", "loading")
      expect(matcher.description).to eq('have Stimulus class "loading" for controller "search"')
    end

    it "describes the 3-arg form" do
      matcher = have_stimulus_class("search", "loading", "opacity-50")
      expect(matcher.description).to eq('have Stimulus class "loading" with "opacity-50" for controller "search"')
    end
  end
end