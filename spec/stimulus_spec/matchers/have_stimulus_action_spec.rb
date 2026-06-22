# frozen_string_literal: true

RSpec.describe StimulusSpec::Matchers::HaveStimulusAction do
  include StimulusSpec::Matchers

  describe "#matches?" do
    it "matches a full action descriptor" do
      html = '<button data-action="click->hello#greet"></button>'
      expect(html).to have_stimulus_action("click->hello#greet")
    end

    it "does not match when data-action is absent" do
      html = "<button></button>"
      expect(html).not_to have_stimulus_action("click->hello#greet")
    end

    it "matches one of multiple actions" do
      html = '<button data-action="click->hello#greet mouseover->hello#hover"></button>'
      expect(html).to have_stimulus_action("mouseover->hello#hover")
    end

    it "does not partially match full descriptors" do
      html = '<button data-action="click->hello#greet"></button>'
      expect(html).not_to have_stimulus_action("click->hello#greetings")
    end

    it "matches shorthand descriptors without event" do
      html = '<button data-action="click->hello#greet"></button>'
      expect(html).to have_stimulus_action("hello#greet")
    end

    it "does not match shorthand when controller differs" do
      html = '<button data-action="click->hello#greet"></button>'
      expect(html).not_to have_stimulus_action("other#greet")
    end

    it "matches actions on nested elements" do
      html = '<form><button data-action="click->hello#greet"></button></form>'
      expect(html).to have_stimulus_action("click->hello#greet")
    end

    it "duck-types response objects with .body" do
      response = double(body: '<button data-action="click->hello#greet"></button>')
      expect(response).to have_stimulus_action("click->hello#greet")
    end
  end

  describe "#failure_message" do
    it "includes the expected descriptor and HTML" do
      html = "<button></button>"
      matcher = have_stimulus_action("click->hello#greet")
      matcher.matches?(html)
      expect(matcher.failure_message).to include("click->hello#greet")
      expect(matcher.failure_message).to include("<button></button>")
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the expected descriptor" do
      html = '<button data-action="click->hello#greet"></button>'
      matcher = have_stimulus_action("click->hello#greet")
      matcher.matches?(html)
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