# frozen_string_literal: true

require "capybara"

RSpec.describe StimulusSpec::Capybara::Matchers::HaveStimulusController do
  include StimulusSpec::Capybara::Matchers

  describe "#matches?" do
    it "matches when data-controller is present" do
      page = ::Capybara.string('<div data-controller="hello"></div>')
      expect(page).to have_stimulus_controller("hello")
    end

    it "does not match when data-controller is absent" do
      page = ::Capybara.string("<div></div>")
      expect(page).not_to have_stimulus_controller("hello")
    end

    it "matches one of multiple controllers" do
      page = ::Capybara.string('<div data-controller="hello clipboard"></div>')
      expect(page).to have_stimulus_controller("clipboard")
    end

    it "does not partially match controller names" do
      page = ::Capybara.string('<div data-controller="hello-world"></div>')
      expect(page).not_to have_stimulus_controller("hello")
    end
  end

  describe "multi-controller" do
    it "matches when all controllers are on a single element" do
      page = ::Capybara.string('<div data-controller="hello clipboard"></div>')
      expect(page).to have_stimulus_controller("hello", "clipboard")
    end

    it "does not match when some controllers are missing" do
      page = ::Capybara.string('<div data-controller="hello"></div>')
      expect(page).not_to have_stimulus_controller("hello", "clipboard")
    end

    it "does not match when none are present" do
      page = ::Capybara.string("<div></div>")
      expect(page).not_to have_stimulus_controller("hello", "clipboard")
    end
  end

  describe "#within" do
    it "matches within the given selector" do
      page = ::Capybara.string('<form class="search"><div data-controller="hello"></div></form>')
      expect(page).to have_stimulus_controller("hello").within(".search")
    end

    it "does not match outside the given selector" do
      page = ::Capybara.string('<div data-controller="hello"></div><form class="search"></form>')
      expect(page).not_to have_stimulus_controller("hello").within(".search")
    end
  end

  describe "#does_not_match?" do
    it "uses has_no_css? for negation" do
      page = ::Capybara.string("<div></div>")
      matcher = have_stimulus_controller("hello")
      expect(matcher.does_not_match?(page)).to be true
    end
  end

  describe "#failure_message" do
    it "includes the expected controller name" do
      matcher = have_stimulus_controller("hello")
      matcher.matches?(::Capybara.string("<div></div>"))
      expect(matcher.failure_message).to include("hello")
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the expected controller name" do
      matcher = have_stimulus_controller("hello")
      matcher.matches?(::Capybara.string('<div data-controller="hello"></div>'))
      expect(matcher.failure_message_when_negated).to include("hello")
    end
  end

  describe "#description" do
    it "describes the matcher" do
      matcher = have_stimulus_controller("hello")
      expect(matcher.description).to eq('have Stimulus controller "hello"')
    end
  end
end