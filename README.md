# StimulusSpec

[![CI](https://github.com/eclectic-coding/stimulus_spec/actions/workflows/main.yml/badge.svg)](https://github.com/eclectic-coding/stimulus_spec/actions/workflows/main.yml)
[![Gem Version](https://img.shields.io/gem/v/stimulus_spec)](https://rubygems.org/gems/stimulus_spec)
[![Gem Downloads](https://img.shields.io/gem/dt/stimulus_spec)](https://rubygems.org/gems/stimulus_spec)
[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%203.3-ruby)](https://rubygems.org/gems/stimulus_spec)
[![codecov](https://codecov.io/gh/eclectic-coding/stimulus_spec/branch/main/graph/badge.svg)](https://codecov.io/gh/eclectic-coding/stimulus_spec)

Drop-in RSpec matchers for [hotwired/stimulus-rails](https://github.com/hotwired/stimulus-rails) — stop hand-rolling `data-controller` assertions and test your Stimulus wiring with expressive, purpose-built matchers.

- **Request/controller specs** — `have_stimulus_controller`, `have_stimulus_action`, `have_stimulus_target`, `have_stimulus_value`, `have_stimulus_class`, `have_stimulus_outlet`
- **System/feature specs** — Capybara matchers: `have_stimulus_controller`, `have_stimulus_action`, `have_stimulus_target`, `have_stimulus_value`
- **Auto-included** — zero setup required when `stimulus-rails` is in your bundle

Companion gem to [turbo_rspec](https://github.com/eclectic-coding/turbo_rspec) — together they cover the full Hotwire testing stack.

## Installation

Add to your application's `Gemfile`:

```ruby
group :test do
  gem "stimulus_spec"
end
```

## Setup

### Rails + stimulus-rails (automatic)

No setup needed. When `stimulus-rails` is in your bundle:

- `StimulusSpec::Matchers` is automatically included in all `type: :request` and `type: :controller` example groups
- `StimulusSpec::Capybara::Matchers` is automatically included in all `type: :system` and `type: :feature` example groups when `capybara` is also present

### Manual include

For non-Rails projects or custom contexts, include the matchers explicitly:

```ruby
# spec/spec_helper.rb
RSpec.configure do |config|
  config.include StimulusSpec::Matchers                 # request specs
  config.include StimulusSpec::Capybara::Matchers       # system/feature specs
end
```

### Configuration

```ruby
# spec/support/stimulus_spec.rb
StimulusSpec.configure do |config|
  config.auto_include = false  # disable automatic inclusion
end
```

## Matchers

### `have_stimulus_controller`

Assert that rendered HTML contains a `data-controller` attribute with the given controller name.

```ruby
# Request specs — asserts in rendered HTML response
expect(response).to have_stimulus_controller("hello")
expect(response).to have_stimulus_controller("hello", "clipboard")

# System/feature specs — asserts on the live Capybara page
expect(page).to have_stimulus_controller("hello")

# Negation
expect(response).not_to have_stimulus_controller("missing")
```

Uses space-separated token matching, so it works correctly when multiple controllers are declared on a single element.

### `have_stimulus_action`

Assert that rendered HTML contains a `data-action` attribute with the given action descriptor.

```ruby
# Full descriptor
expect(response).to have_stimulus_action("click->hello#greet")

# Shorthand — matches any event
expect(response).to have_stimulus_action("hello#greet")

# System/feature specs
expect(page).to have_stimulus_action("click->hello#greet")

# Negation
expect(response).not_to have_stimulus_action("hello#disconnect")
```

### `have_stimulus_target`

Assert that rendered HTML contains a `data-{controller}-target` attribute with the given target name.

```ruby
# Request specs
expect(response).to have_stimulus_target("hello", "name")
expect(response).to have_stimulus_target("hello", "output")

# System/feature specs
expect(page).to have_stimulus_target("hello", "name")

# Negation
expect(response).not_to have_stimulus_target("hello", "missing")
```

### `have_stimulus_value`

Assert that rendered HTML contains a `data-{controller}-{name}-value` attribute, optionally with a specific value.

```ruby
# Assert the value attribute exists
expect(response).to have_stimulus_value("search", "url")

# Assert a specific value
expect(response).to have_stimulus_value("search", "url", "/results")

# System/feature specs
expect(page).to have_stimulus_value("search", "url", "/results")

# Negation
expect(response).not_to have_stimulus_value("search", "url")
```

### `have_stimulus_class`

Assert that rendered HTML contains a `data-{controller}-{name}-class` attribute.

```ruby
# Assert the class attribute exists
expect(response).to have_stimulus_class("search", "loading", "opacity-50")

# Negation
expect(response).not_to have_stimulus_class("search", "loading")
```

### `have_stimulus_outlet`

Assert that rendered HTML contains a `data-{controller}-{outlet}-outlet` attribute with a CSS selector.

```ruby
# Assert the outlet attribute exists
expect(response).to have_stimulus_outlet("search", "results")

# Assert a specific selector
expect(response).to have_stimulus_outlet("search", "results", "#results-list")

# Negation
expect(response).not_to have_stimulus_outlet("search", "results")
```

## Example: request spec

```ruby
RSpec.describe "Search", type: :request do
  describe "GET /search" do
    it "wires up the search controller with values" do
      get search_path

      expect(response).to have_stimulus_controller("search")
      expect(response).to have_stimulus_action("input->search#query")
      expect(response).to have_stimulus_target("search", "input")
      expect(response).to have_stimulus_value("search", "url", "/results")
    end
  end
end
```

## Example: system spec

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

## Relationship to turbo_rspec

[turbo_rspec](https://github.com/eclectic-coding/turbo_rspec) includes basic Stimulus matchers (`have_stimulus_controller`, `have_stimulus_action`, `have_stimulus_target`). **stimulus_spec** goes deeper with value, class, and outlet matchers, plus richer failure messages and Stimulus-specific configuration. If you only need basic controller/action/target assertions alongside your Turbo matchers, turbo_rspec has you covered. If you want comprehensive Stimulus testing, use stimulus_spec.

Both gems can coexist — they use separate namespaces and won't conflict.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/eclectic-coding/stimulus_spec). See [CONTRIBUTING.md](CONTRIBUTING.md) for setup instructions, branch conventions, CHANGELOG requirements, and the PR checklist.

## License

The gem is available as open source under the [MIT License](https://opensource.org/licenses/MIT).