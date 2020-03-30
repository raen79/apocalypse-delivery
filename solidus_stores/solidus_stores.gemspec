# frozen_string_literal: true

require_relative 'lib/solidus_stores/version'

Gem::Specification.new do |spec|
  spec.name = 'solidus_stores'
  spec.version = SolidusStores::VERSION
  spec.authors = ['Val']
  spec.email = 'arkhipov.valentin@gmail.com'

  spec.summary = 'Provides a way to trade with many companies in one site'
  spec.description = 'Provides a way to trade with many companies in one site'
  spec.homepage = 'https://github.com/raen79/apocalypse-delivery'
  spec.license = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/raen79/apocalypse-delivery'
  spec.metadata['changelog_uri'] = 'https://github.com/raen79/apocalypse-delivery/releases'

  spec.required_ruby_version = Gem::Requirement.new('~> 2.4')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  spec.files = files.grep_v(%r{^(test|spec|features)/})
  spec.test_files = files.grep(%r{^(test|spec|features)/})
  spec.bindir = "exe"
  spec.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'solidus_core', ['>= 2.0.0', '< 3']
  spec.add_dependency 'solidus_support', '~> 0.4.0'

  spec.add_development_dependency 'solidus_dev_support'
end
