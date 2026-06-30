# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.8.1] - 2026-06-30

### Fixed

- Guard matcher requires and `RSpec.configure` behind `defined?(RSpec::Core)` so the gem is safe to auto-require in non-test contexts (e.g. asset precompilation). Previously, a partial load of `rspec-expectations` or `rspec-mocks` could define the `RSpec` constant without `RSpec::Core`, causing a `NoMethodError` when `RSpec.configure` was called. Nokogiri is now also only required when RSpec::Core is present.

## [0.8.0] - 2026-06-23

### Added

- `bin/benchmark` script for measuring matcher overhead
- Version spec enforcing semver format on `StimulusSpec::VERSION`
- `docs/migration_guide.md` for migrating from turbo_rspec's Stimulus matchers
- Guiding principles section in README

## [0.7.0] - 2026-06-23

### Added

- Full YARD documentation (`@param`, `@return`, `@example`) on all public methods and classes
- `docs/cookbook.md` with common patterns: request specs, system specs, multi-controller, scoped matching, typed values, outlets
- `.yardopts` configuration file

## [0.6.0] - 2026-06-23

### Added

- Multi-controller assertion: `have_stimulus_controller("hello", "clipboard")` asserts multiple controllers on a single element
- Scoped matching via `.within(selector)` on all matchers (request-spec and Capybara)

## [0.5.0] - 2026-06-23

### Added

- Capybara `have_stimulus_class` matcher (existence and equality modes) for system/feature specs
- Capybara `have_stimulus_outlet` matcher (existence and selector modes) for system/feature specs

## [0.4.0] - 2026-06-22

### Added

- `have_stimulus_outlet(controller, outlet)` matcher — asserts `data-{controller}-{outlet}-outlet` exists
- `have_stimulus_outlet(controller, outlet, selector)` matcher — asserts attribute equals the CSS selector value
- Capybara matchers: `have_stimulus_controller`, `have_stimulus_action`, `have_stimulus_target` for system/feature specs
- Auto-include `StimulusSpec::Capybara::Matchers` into `type: :system` and `type: :feature` (gated on `capybara`)
- Capybara `have_stimulus_value` matcher (existence and equality modes)
- Enhanced failure messages: controller mismatch lists all found controllers, value/class/outlet mismatch shows actual vs expected with element HTML, all matchers include relevant HTML snippets

## [0.3.0] - 2026-06-22

### Added

- `have_stimulus_value(controller, name)` matcher — asserts `data-{controller}-{name}-value` exists
- `have_stimulus_value(controller, name, expected)` matcher — asserts attribute equals expected value
- `have_stimulus_class(controller, name)` matcher — asserts `data-{controller}-{name}-class` exists
- `have_stimulus_class(controller, name, expected)` matcher — asserts attribute equals expected class

## [0.1.0] - 2026-06-22

### Added

- `StimulusSpec::Configuration` class with `auto_include` attribute (default `true`)
- `StimulusSpec.configure`, `.configuration`, and `.reset_configuration!` class methods
- `StimulusSpec.install_rspec_integration` — auto-includes matchers into `type: :request`, `:controller`, `:system`, and `:feature` example groups (gated on `stimulus-rails`)
- `RSpec.configure` hook at load time (guarded by `defined?(RSpec)`)
- `have_stimulus_controller(name)` matcher — asserts `[data-controller~="name"]` via Nokogiri
- `have_stimulus_action(descriptor)` matcher — full descriptor (`~=`) and shorthand without event (`*=`)
- `have_stimulus_target(controller, target)` matcher — asserts `[data-{controller}-target~="target"]`

[Unreleased]: https://github.com/eclectic-coding/stimulus_spec/compare/v0.8.1...HEAD
[0.8.1]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.8.1
[0.8.0]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.8.0
[0.7.0]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.7.0
[0.6.0]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.6.0
[0.5.0]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.5.0
[0.4.0]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.4.0
[0.3.0]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.3.0
[0.1.0]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.1.0
