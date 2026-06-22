# frozen_string_literal: true

require "capybara"

RSpec.describe StimulusSpec::Capybara::Matchers::HaveStimulusTarget do
  include StimulusSpec::Capybara::Matchers

  describe "#matches?" do
    it "matches when target attribute is present" do
      page = ::Capybara.string('<input data-hello-target="name">')
      expect(page).to have_stimulus_target("hello", "name")
    end

    it "does not match when target attribute is absent" do
      page = ::Capybara.string("<input>")
      expect(page).not_to have_stimulus_target("hello", "name")
    end

    it "matches one of multiple targets" do
      page = ::Capybara.string('<input data-hello-target="name output">')
      expect(page).to have_stimulus_target("hello", "output")
    end

    it "does not partially match target names" do
      page = ::Capybara.string('<input data-hello-target="nameField">')
      expect(page).not_to have_stimulus_target("hello", "name")
    end
  end

  describe "#does_not_match?" do
    it "uses has_no_css? for negation" do
      page = ::Capybara.string("<input>")
      matcher = have_stimulus_target("hello", "name")
      expect(matcher.does_not_match?(page)).to be true
    end
  end

  describe "#failure_message" do
    it "includes the controller and target" do
      matcher = have_stimulus_target("hello", "name")
      matcher.matches?(::Capybara.string("<input>"))
      expect(matcher.failure_message).to include("data-hello-target")
      expect(matcher.failure_message).to include("name")
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the controller and target" do
      matcher = have_stimulus_target("hello", "name")
      matcher.matches?(::Capybara.string('<input data-hello-target="name">'))
      expect(matcher.failure_message_when_negated).to include("data-hello-target")
      expect(matcher.failure_message_when_negated).to include("name")
    end
  end

  describe "#description" do
    it "describes the matcher" do
      matcher = have_stimulus_target("hello", "name")
      expect(matcher.description).to eq('have Stimulus target "name" for controller "hello"')
    end
  end
end