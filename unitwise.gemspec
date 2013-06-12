# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unitwise/version'

Gem::Specification.new do |gem|
  gem.name          = "unitwise"
  gem.version       = Unitwise::VERSION
  gem.authors       = ["Josh Lewis"]
  gem.email         = ["josh.w.lewis@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "signed_multiset"

  gem.add_development_dependency "minitest"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "nori"
  gem.add_development_dependency "nokogiri"
end
