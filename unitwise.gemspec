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

  gem.add_dependency "liner", "~> 0.2"
  gem.add_dependency "signed_multiset", "~> 0.2"
  gem.add_dependency "parslet", "~> 1.5"

  gem.add_development_dependency "minitest",  ">= 5.0"
  gem.add_development_dependency "rake",      ">= 10.0"
  gem.add_development_dependency "nori",      "~> 2.3"
  gem.add_development_dependency "nokogiri",  "~> 1.6"
  gem.add_development_dependency "coveralls", "~> 0.6"
end
