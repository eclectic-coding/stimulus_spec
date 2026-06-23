# StimulusSpec Cookbook

Common patterns for testing Stimulus wiring with `stimulus_spec`.

## Request specs

```ruby
RSpec.describe "Search", type: :request do
  describe "GET /search" do
    before { get search_path }

    it "wires up the search controller" do
      expect(response).to have_stimulus_controller("search")
      expect(response).to have_stimulus_action("input->search#query")
      expect(response).to have_stimulus_target("search", "input")
    end

    it "sets the URL value" do
      expect(response).to have_stimulus_value("search", "url", "/results")
    end
  end
end
```

## System specs

```ruby
RSpec.describe "Search", type: :system do
  it "has the search controller wired up" do
    visit search_path

    expect(page).to have_stimulus_controller("search")
    expect(page).to have_stimulus_action("input->search#query")
    expect(page).to have_stimulus_target("search", "input")
  end
end
```

## Multi-controller elements

When a single element declares multiple Stimulus controllers, assert them all at once:

```ruby
# Assert both controllers are on the same element
expect(response).to have_stimulus_controller("dropdown", "keyboard-nav")
```

Or assert them individually:

```ruby
expect(response).to have_stimulus_controller("dropdown")
expect(response).to have_stimulus_controller("keyboard-nav")
```

## Scoped matching

Use `.within(selector)` to restrict matching to a specific part of the page. Useful when the same controller appears in multiple places:

```ruby
# Only match within the sidebar
expect(response).to have_stimulus_controller("nav").within(".sidebar")

# Assert a target exists within a specific form
expect(response).to have_stimulus_target("search", "input").within("#search-form")

# Works with all matchers
expect(response).to have_stimulus_action("click->tabs#select").within(".tab-bar")
expect(response).to have_stimulus_value("editor", "language", "ruby").within(".code-panel")
expect(response).to have_stimulus_class("menu", "active", "bg-blue-500").within("nav")
expect(response).to have_stimulus_outlet("search", "results", "#results-list").within(".search-form")
```

Scoped matching works the same way with Capybara matchers in system/feature specs:

```ruby
expect(page).to have_stimulus_controller("nav").within(".sidebar")
```

## Typed values

Stimulus values are always stored as strings in the DOM. Pass the expected string representation:

```ruby
# Boolean value
expect(response).to have_stimulus_value("toggle", "open", "true")

# Numeric value
expect(response).to have_stimulus_value("pagination", "page", "1")

# JSON value
expect(response).to have_stimulus_value("chart", "data", '{"labels":["Jan","Feb"]}')
```

To assert a value attribute exists without checking its content, use the two-argument form:

```ruby
expect(response).to have_stimulus_value("search", "url")
```

## CSS classes

Assert Stimulus CSS class attributes (`data-{controller}-{name}-class`):

```ruby
# Assert the class attribute exists
expect(response).to have_stimulus_class("search", "loading")

# Assert a specific class value
expect(response).to have_stimulus_class("search", "loading", "opacity-50")
```

## Outlets

Assert Stimulus outlet attributes (`data-{controller}-{outlet}-outlet`):

```ruby
# Assert the outlet attribute exists
expect(response).to have_stimulus_outlet("search", "results")

# Assert a specific CSS selector
expect(response).to have_stimulus_outlet("search", "results", "#results-list")
```

## Negation

All matchers support `not_to`:

```ruby
expect(response).not_to have_stimulus_controller("admin")
expect(response).not_to have_stimulus_action("click->admin#delete")
expect(response).not_to have_stimulus_target("admin", "panel")
expect(response).not_to have_stimulus_value("admin", "role")
expect(response).not_to have_stimulus_class("admin", "active")
expect(response).not_to have_stimulus_outlet("admin", "panel")
```

## Disabling auto-include

By default, matchers are auto-included when `stimulus-rails` is in your bundle. To disable:

```ruby
# spec/support/stimulus_spec.rb
StimulusSpec.configure do |config|
  config.auto_include = false
end

# Then include manually where needed
RSpec.configure do |config|
  config.include StimulusSpec::Matchers, type: :request
  config.include StimulusSpec::Capybara::Matchers, type: :system
end
```