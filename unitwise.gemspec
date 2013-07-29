# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unitwise/version'

Gem::Specification.new do |gem|
  gem.name          = "unitwise"
  gem.version       = Unitwise::VERSION
  gem.authors       = ["Josh Lewis"]
  gem.email         = ["josh.w.lewis@gmail.com"]
  gem.description   = %q{Ruby implementation of the Unified Code for Units of Measure (UCUM)}
  gem.summary       = %q{Unitwise is a library for performing mathematical operations and conversions on all units defined by the Unified Code for Units of Measure(UCUM).}
  gem.homepage      = "http://github.com/joshwlewis/unitwise"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.require_paths = ["lib"]

  gem.add_dependency "signed_multiset"
  gem.add_dependency "parslet"

  gem.add_development_dependency "minitest"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "nori"
  gem.add_development_dependency "nokogiri"
  gem.add_development_dependency "coveralls"
end
