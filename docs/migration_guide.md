# Migrating from turbo_rspec to stimulus_spec

[turbo_rspec](https://github.com/eclectic-coding/turbo_rspec) includes basic Stimulus matchers: `have_stimulus_controller`, `have_stimulus_action`, and `have_stimulus_target`. **stimulus_spec** provides the same three matchers plus `have_stimulus_value`, `have_stimulus_class`, `have_stimulus_outlet`, multi-controller assertions, and scoped matching.

Both gems can coexist — they use separate namespaces (`TurboRspec::Matchers` vs `StimulusSpec::Matchers`) and won't conflict. You can migrate incrementally.

## Step 1: Add stimulus_spec

```ruby
# Gemfile
group :test do
  gem "stimulus_spec"
end
```

```bash
bundle install
```

With `stimulus-rails` in your bundle, `stimulus_spec` auto-includes its matchers into request, controller, system, and feature specs. No configuration needed.

## Step 2: Verify existing tests pass

Your existing turbo_rspec Stimulus matchers (`TurboRspec::Matchers`) will continue to work alongside `StimulusSpec::Matchers`. Run your test suite to confirm nothing breaks:

```bash
bundle exec rspec
```

## Step 3: Switch namespaces (optional)

If you manually include turbo_rspec's Stimulus matchers, update to the stimulus_spec equivalents:

```ruby
# Before
config.include TurboRspec::Matchers, type: :request

# After
config.include StimulusSpec::Matchers, type: :request
config.include StimulusSpec::Capybara::Matchers, type: :system
```

If you rely on auto-include (the default for both gems), this step is unnecessary — both sets of matchers are already available.

## Step 4: Use new matchers

With stimulus_spec installed, you now have access to matchers that turbo_rspec doesn't provide:

```ruby
# Value assertions
expect(response).to have_stimulus_value("search", "url", "/results")

# CSS class assertions
expect(response).to have_stimulus_class("search", "loading", "opacity-50")

# Outlet assertions
expect(response).to have_stimulus_outlet("search", "results", "#results-list")

# Multi-controller on a single element
expect(response).to have_stimulus_controller("hello", "clipboard")

# Scoped matching
expect(response).to have_stimulus_controller("search").within(".search-form")
```

## Matcher comparison

| Matcher | turbo_rspec | stimulus_spec |
|---|---|---|
| `have_stimulus_controller` | Single name | Single or multiple names |
| `have_stimulus_action` | Full or shorthand | Full or shorthand |
| `have_stimulus_target` | Controller + target | Controller + target |
| `have_stimulus_value` | — | Existence or equality |
| `have_stimulus_class` | — | Existence or equality |
| `have_stimulus_outlet` | — | Existence or selector |
| `.within(selector)` | — | All matchers |
| Capybara variants | Controller, action, target | All six matchers |
| Failure messages | Basic | Shows found values and HTML context |

## Step 5: Remove turbo_rspec Stimulus matchers (optional)

If you want to fully consolidate, you can stop including turbo_rspec's Stimulus matchers. turbo_rspec's Turbo-specific matchers (`have_turbo_frame`, `have_turbo_stream`, etc.) are unaffected — only the Stimulus matchers overlap.

If you use turbo_rspec solely for Turbo matchers, no changes are needed. Both gems coexist cleanly.
