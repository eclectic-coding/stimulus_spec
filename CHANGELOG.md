# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `StimulusSpec::Configuration` class with `auto_include` attribute (default `true`)
- `StimulusSpec.configure`, `.configuration`, and `.reset_configuration!` class methods
- `StimulusSpec.install_rspec_integration` — auto-includes matchers into `type: :request`, `:controller`, `:system`, and `:feature` example groups (gated on `stimulus-rails`)
- `RSpec.configure` hook at load time (guarded by `defined?(RSpec)`)
- `have_stimulus_controller(name)` matcher — asserts `[data-controller~="name"]` via Nokogiri
- `have_stimulus_action(descriptor)` matcher — full descriptor (`~=`) and shorthand without event (`*=`)
- `have_stimulus_target(controller, target)` matcher — asserts `[data-{controller}-target~="target"]`

[Unreleased]: https://github.com/eclectic-coding/stimulus_spec/compare/main...HEAD
