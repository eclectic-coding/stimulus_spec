# frozen_string_literal: true

RSpec.describe StimulusSpec::Matchers::HaveStimulusController do
  include StimulusSpec::Matchers

  describe "#matches?" do
    it "matches when data-controller is present" do
      html = '<div data-controller="hello"></div>'
      expect(html).to have_stimulus_controller("hello")
    end

    it "does not match when data-controller is absent" do
      html = "<div></div>"
      expect(html).not_to have_stimulus_controller("hello")
    end

    it "matches one of multiple controllers" do
      html = '<div data-controller="hello clipboard"></div>'
      expect(html).to have_stimulus_controller("clipboard")
    end

    it "does not partially match controller names" do
      html = '<div data-controller="hello-world"></div>'
      expect(html).not_to have_stimulus_controller("hello")
    end

    it "matches controllers on nested elements" do
      html = '<section><div data-controller="hello"></div></section>'
      expect(html).to have_stimulus_controller("hello")
    end

    it "duck-types response objects with .body" do
      response = double(body: '<div data-controller="hello"></div>')
      expect(response).to have_stimulus_controller("hello")
    end
  end

  describe "#failure_message" do
    it "includes the expected controller name and HTML" do
      html = "<div></div>"
      matcher = have_stimulus_controller("hello")
      matcher.matches?(html)
      expect(matcher.failure_message).to include("hello")
      expect(matcher.failure_message).to include("<div></div>")
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the expected controller name" do
      html = '<div data-controller="hello"></div>'
      matcher = have_stimulus_controller("hello")
      matcher.matches?(html)
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