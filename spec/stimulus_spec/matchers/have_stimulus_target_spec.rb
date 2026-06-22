# frozen_string_literal: true

RSpec.describe StimulusSpec::Matchers::HaveStimulusTarget do
  include StimulusSpec::Matchers

  describe "#matches?" do
    it "matches when target attribute is present" do
      html = '<input data-hello-target="name">'
      expect(html).to have_stimulus_target("hello", "name")
    end

    it "does not match when target attribute is absent" do
      html = "<input>"
      expect(html).not_to have_stimulus_target("hello", "name")
    end

    it "matches one of multiple targets" do
      html = '<input data-hello-target="name output">'
      expect(html).to have_stimulus_target("hello", "output")
    end

    it "does not partially match target names" do
      html = '<input data-hello-target="nameField">'
      expect(html).not_to have_stimulus_target("hello", "name")
    end

    it "matches targets on nested elements" do
      html = '<div><input data-hello-target="name"></div>'
      expect(html).to have_stimulus_target("hello", "name")
    end

    it "duck-types response objects with .body" do
      response = double(body: '<input data-hello-target="name">')
      expect(response).to have_stimulus_target("hello", "name")
    end
  end

  describe "#failure_message" do
    it "includes the controller, target, and HTML" do
      html = "<input>"
      matcher = have_stimulus_target("hello", "name")
      matcher.matches?(html)
      expect(matcher.failure_message).to include("data-hello-target")
      expect(matcher.failure_message).to include("name")
      expect(matcher.failure_message).to include("<input>")
    end

    it "lists found targets when others exist" do
      html = '<input data-hello-target="output">'
      matcher = have_stimulus_target("hello", "name")
      matcher.matches?(html)
      expect(matcher.failure_message).to include('"output"')
    end
  end

  describe "#failure_message_when_negated" do
    it "includes the controller and target" do
      html = '<input data-hello-target="name">'
      matcher = have_stimulus_target("hello", "name")
      matcher.matches?(html)
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