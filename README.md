# StimulusSpec

[![CI](https://github.com/eclectic-coding/stimulus_spec/actions/workflows/main.yml/badge.svg)](https://github.com/eclectic-coding/stimulus_spec/actions/workflows/main.yml)
[![Gem Version](https://img.shields.io/gem/v/stimulus_spec)](https://rubygems.org/gems/stimulus_spec)
[![Gem Downloads](https://img.shields.io/gem/dt/stimulus_spec)](https://rubygems.org/gems/stimulus_spec)
[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%203.3-ruby)](https://rubygems.org/gems/stimulus_spec)
[![codecov](https://codecov.io/gh/eclectic-coding/stimulus_spec/branch/main/graph/badge.svg)](https://codecov.io/gh/eclectic-coding/stimulus_spec)

Drop-in RSpec matchers for [hotwired/stimulus-rails](https://github.com/hotwired/stimulus-rails) — stop hand-rolling `data-controller` assertions and test your Stimulus wiring with expressive, purpose-built matchers.

- **Auto-included** — zero setup required when `stimulus-rails` is in your bundle
- **Configurable** — disable auto-include when you need manual control

Companion gem to [turbo_rspec](https://github.com/eclectic-coding/turbo_rspec) — together they cover the full Hotwire testing stack.

> **Note:** This gem is under active development. Matchers (`have_stimulus_controller`, `have_stimulus_action`, `have_stimulus_target`, etc.) are coming in upcoming releases. See the [ROADMAP](ROADMAP.md) for planned features.

## Installation

Add to your application's `Gemfile`:

```ruby
group :test do
  gem "stimulus_spec"
end
```

## Setup

### Rails + stimulus-rails (automatic)

No setup needed. When `stimulus-rails` is in your bundle, `StimulusSpec::Matchers` is automatically included in `type: :request`, `:controller`, `:system`, and `:feature` example groups.

### Manual include

For non-Rails projects or custom contexts, include the matchers explicitly:

```ruby
# spec/spec_helper.rb
RSpec.configure do |config|
  config.include StimulusSpec::Matchers
end
```

### Configuration

```ruby
# spec/support/stimulus_spec.rb
StimulusSpec.configure do |config|
  config.auto_include = false  # disable automatic inclusion
end
```

## Relationship to turbo_rspec

[turbo_rspec](https://github.com/eclectic-coding/turbo_rspec) includes basic Stimulus matchers (`have_stimulus_controller`, `have_stimulus_action`, `have_stimulus_target`). **stimulus_spec** goes deeper with value, class, and outlet matchers, plus richer failure messages and Stimulus-specific configuration. If you only need basic controller/action/target assertions alongside your Turbo matchers, turbo_rspec has you covered. If you want comprehensive Stimulus testing, use stimulus_spec.

Both gems can coexist — they use separate namespaces and won't conflict.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/eclectic-coding/stimulus_spec). See [CONTRIBUTING.md](CONTRIBUTING.md) for setup instructions, branch conventions, CHANGELOG requirements, and the PR checklist.

## License

The gem is available as open source under the [MIT License](https://opensource.org/licenses/MIT).