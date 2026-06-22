# frozen_string_literal: true

require "capybara"

RSpec.describe StimulusSpec::Capybara::Matchers::HaveStimulusAction do
  include StimulusSpec::Capybara::Matchers

  describe "#matches?" do
    it "matches a full action descriptor" do
      page = ::Capybara.string('<button data-action="click->hello#greet"></button>')
      expect(page).to have_stimulus_action("click->hello#greet")
    end

    it "does not match when data-action is absent" do
      page = ::Capybara.string("<button></button>")
      expect(page).not_to have_stimulus_action("click->hello#greet")
    end

    it "matches one of multiple actions" do
      page = ::Capybara.string('<button data-action="click->hello#greet mouseover->hello#hover"></button>')
      expect(page).to have_stimulus_action("mouseover->hello#hover")
    end

    it "matches shorthand descriptors without event" do
      page = ::Capybara.string('<button data-action="click->hello#greet"></button>')
      expect(page).to have_stimulus_action("hello#greet")
    end
  end

  describe "#does_not_match?" do
    it "uses has_no_css? for negation" do
      page = ::Capybara.string("<button></button>")
      matcher = have_stimulus_action("click->hello#greet")
      expect(matcher.does_not_match?(page)).to be true
    end
  end

  describe "#failure_message" do
    it "includes the expected descriptor" do
      matcher = have_stimulus_action("click->hello#greet")
      matcher.matches?(::Capybara.string("<button></button>"))
      expect(matcher.failure_message).to include("click->hello#greet")
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the expected descriptor" do
      matcher = have_stimulus_action("click->hello#greet")
      matcher.matches?(::Capybara.string('<button data-action="click->hello#greet"></button>'))
      expect(matcher.failure_message_when_negated).to include("click->hello#greet")
    end
  end

  describe "#description" do
    it "describes the matcher" do
      matcher = have_stimulus_action("click->hello#greet")
      expect(matcher.description).to eq('have Stimulus action "click->hello#greet"')
    end
  end
end