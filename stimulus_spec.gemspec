# frozen_string_literal: true

require_relative "lib/stimulus_spec/version"

Gem::Specification.new do |spec|
  spec.name = "stimulus_spec"
  spec.version = StimulusSpec::VERSION
  spec.authors = ["Chuck Smith"]
  spec.email = ["eclectic-coding@users.noreply.github.com"]

  spec.summary = "RSpec matchers for testing Stimulus controllers in Rails applications."
  spec.description = "Drop-in RSpec matchers for hotwired/stimulus-rails: assert Stimulus controllers, " \
                     "actions, targets, values, classes, and outlets in your view and system specs. " \
                     "Includes Capybara matchers for live-page assertions and request-spec matchers " \
                     "for rendered HTML — all auto-included with zero setup."
  spec.homepage = "https://github.com/eclectic-coding/stimulus_spec"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/eclectic-coding/stimulus_spec"
  spec.metadata["changelog_uri"] = "https://github.com/eclectic-coding/stimulus_spec/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", ">= 1.13"
end
