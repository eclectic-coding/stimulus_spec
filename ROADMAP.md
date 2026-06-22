# stimulus_spec Roadmap

RSpec matchers for [Stimulus](https://github.com/hotwired/stimulus-rails): controllers, actions, targets, values, classes, and outlets. The goal is to replace hand-rolled `data-controller` assertions with expressive, purpose-built matchers.

## Guiding principles

- **Zero magic by default.** Auto-include only when it's unambiguous (Rails request specs with `stimulus-rails` present). Everything else is opt-in.
- **Fail loudly with useful output.** A cryptic failure message is a bug. Show what was expected, what was found, and the relevant HTML.
- **Stay close to Stimulus conventions.** Matcher names and arguments mirror Stimulus's `data-*` attribute conventions so the docs cross-reference naturally.
- **Pure test helper.** No Rails engine, no generators, no runtime code — just matchers you include in your specs.

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
