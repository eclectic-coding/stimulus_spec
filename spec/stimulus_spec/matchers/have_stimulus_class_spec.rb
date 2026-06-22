# frozen_string_literal: true

RSpec.describe StimulusSpec::Matchers::HaveStimulusClass do
  include StimulusSpec::Matchers

  describe "#matches?" do
    it "matches when class attribute exists (2-arg form)" do
      html = '<div data-search-loading-class="opacity-50"></div>'
      expect(html).to have_stimulus_class("search", "loading")
    end

    it "does not match when class attribute is absent" do
      html = "<div></div>"
      expect(html).not_to have_stimulus_class("search", "loading")
    end

    it "matches when class equals expected (3-arg form)" do
      html = '<div data-search-loading-class="opacity-50"></div>'
      expect(html).to have_stimulus_class("search", "loading", "opacity-50")
    end

    it "does not match when class differs from expected" do
      html = '<div data-search-loading-class="hidden"></div>'
      expect(html).not_to have_stimulus_class("search", "loading", "opacity-50")
    end

    it "works with hyphenated controller names" do
      html = '<div data-date-picker-active-class="bg-blue"></div>'
      expect(html).to have_stimulus_class("date-picker", "active", "bg-blue")
    end

    it "matches on nested elements" do
      html = '<section><div data-search-loading-class="opacity-50"></div></section>'
      expect(html).to have_stimulus_class("search", "loading")
    end

    it "duck-types response objects with .body" do
      response = double(body: '<div data-search-loading-class="opacity-50"></div>')
      expect(response).to have_stimulus_class("search", "loading")
    end
  end

  describe "#failure_message" do
    it "shows actual vs expected on class mismatch with element HTML" do
      html = '<div data-search-loading-class="hidden"></div>'
      matcher = have_stimulus_class("search", "loading", "opacity-50")
      matcher.matches?(html)
      expect(matcher.failure_message).to include("opacity-50")
      expect(matcher.failure_message).to include("hidden")
      expect(matcher.failure_message).to include("on:")
    end

    it "shows the HTML when attribute is missing" do
      html = "<div></div>"
      matcher = have_stimulus_class("search", "loading")
      matcher.matches?(html)
      expect(matcher.failure_message).to include("data-search-loading-class")
      expect(matcher.failure_message).to include("<div></div>")
    end

    it "shows relevant controller elements when attribute is missing" do
      html = '<div data-controller="search"></div>'
      matcher = have_stimulus_class("search", "loading")
      matcher.matches?(html)
      expect(matcher.failure_message).to include("data-controller")
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the attribute name" do
      html = '<div data-search-loading-class="opacity-50"></div>'
      matcher = have_stimulus_class("search", "loading")
      matcher.matches?(html)
      expect(matcher.failure_message_when_negated).to include("data-search-loading-class")
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