# stimulus_spec Roadmap

RSpec matchers for [Stimulus](https://github.com/hotwired/stimulus-rails): controllers, actions, targets, values, classes, and outlets. The goal is to replace hand-rolled `data-controller` assertions with expressive, purpose-built matchers.

## Guiding principles

- **Zero magic by default.** Auto-include only when it's unambiguous (Rails request specs with `stimulus-rails` present). Everything else is opt-in.
- **Fail loudly with useful output.** A cryptic failure message is a bug. Show what was expected, what was found, and the relevant HTML.
- **Stay close to Stimulus conventions.** Matcher names and arguments mirror Stimulus's `data-*` attribute conventions so the docs cross-reference naturally.
- **Pure test helper.** No Rails engine, no generators, no runtime code — just matchers you include in your specs.

---

## 0.3.0 — Outlets and Capybara Foundation

- `have_stimulus_outlet("search", "results")` — assert `data-search-results-outlet` exists
- `have_stimulus_outlet("search", "results", "#results-list")` — assert selector value
- Capybara matchers: `have_stimulus_controller`, `have_stimulus_action`, `have_stimulus_target` using `has_css?` / `has_no_css?` with `wait: 0`
- Auto-include `StimulusSpec::Capybara::Matchers` into `type: :system` and `type: :feature` (gated on `capybara`)

---

## 0.4.0 — Capybara Values and Rich Failures

- Capybara `have_stimulus_value` matcher
- Enhanced failure messages across all matchers:
  - List all `data-controller` values found in the document on controller mismatch
  - Show actual vs expected value on value/class/outlet mismatch
  - Include relevant HTML snippet for context

---

## 0.5.0 — Documentation and Polish

- Full YARD documentation on all public methods and classes
- `docs/cookbook.md` — common patterns: request specs, system specs, multi-controller elements, typed values, outlets
- Graceful no-op when `stimulus-rails` is not bundled (no `LoadError`)

---

## 1.0.0 — Stable API

- API freeze — public method signatures are part of the semver contract
- `bin/benchmark` — matcher overhead measurement
- Version spec (semver format enforced)
- `docs/migration_guide.md` — migrating from turbo_rspec's Stimulus matchers to stimulus_spec
