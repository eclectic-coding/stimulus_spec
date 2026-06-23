# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/eclectic-coding/stimulus_spec/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.5.0
[0.4.0]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.4.0
[0.3.0]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.3.0
[0.1.0]: https://github.com/eclectic-coding/stimulus_spec/releases/tag/v0.1.0
