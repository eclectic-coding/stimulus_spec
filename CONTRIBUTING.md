# Contributing to stimulus_spec

Bug reports and pull requests are welcome. This guide covers everything you need to get up and running.

## Setup

```bash
git clone https://github.com/eclectic-coding/stimulus_spec.git
cd stimulus_spec
bin/setup          # installs gems
```

## Running the suite

```bash
bundle exec rake                        # full suite: lint + tests (what CI runs)
bundle exec rspec                       # tests only
bundle exec rspec spec/path/to/foo_spec.rb       # single file
bundle exec rspec spec/path/to/foo_spec.rb:42    # single example
bundle exec rubocop                     # lint only
```

## Branch workflow

Always work on a feature or chore branch — never commit directly to `main`:

```
feat/short-description    # new matchers, new API
chore/short-description   # docs, tooling, dependency bumps
fix/short-description     # bug fixes
```

## CHANGELOG

Add an entry under `## [Unreleased]` **on your branch before opening a PR**, not after merging. Use these section headers in order (omit any that have no entries):

```markdown
### Added
### Changed
### Fixed
```

CHANGELOG entries are **user-facing only** — document changes to the public API. Pure internal refactors, docs updates, and CI fixes don't need an entry.

## Pull requests

1. Open a PR against `main`.
2. All CI checks must pass: lint, security audit, and the full test matrix (Ruby 3.3–4.0).
3. Link the relevant GitHub issue in the PR description (`Closes #N`).

## Code conventions

- **RuboCop** enforces style — run `bundle exec rubocop -A` to auto-correct before pushing.
- New public methods need YARD `@param` and `@return` tags, and an entry in `sig/stimulus_spec.rbs`.
- Private helpers don't need YARD docs.

## Releasing (maintainers only)

Releases are cut from `main` using the release script:

```bash
bin/release 1.2.0
```

This bumps the version, updates `CHANGELOG.md` and `Gemfile.lock`, commits, tags, and pushes. CI picks up the tag and publishes to RubyGems via Trusted Publishing.