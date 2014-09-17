# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fixtory/version'

Gem::Specification.new do |spec|
  spec.name          = "fixtory"
  spec.version       = Fixtory::VERSION
  spec.authors       = ["Brian Cardarella"]
  spec.email         = ["bcardarella@gmail.com"]
  spec.summary       = %q{Fixtures and Factories living together, mass hysterica}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/dockyard/fixtory"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '~> 4.1'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "database_cleaner", "~> 1.3"
  spec.add_development_dependency "sqlite3"
end
