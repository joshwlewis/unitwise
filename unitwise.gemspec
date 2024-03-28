# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unitwise/version'

Gem::Specification.new do |gem|
  gem.name          = 'unitwise'
  gem.version       = Unitwise::VERSION
  gem.authors       = ['Josh Lewis']
  gem.email         = ['josh.w.lewis@gmail.com']
  gem.description   = 'Physical quantity and units of measure conversion '    \
                      'and math library'
  gem.summary       = 'Convert between and perform mathematical operations '  \
                      'on physical quantities and units of measure defined '  \
                      'by the Unified Code for Units of Measure.'
  gem.homepage      = 'http://github.com/joshwlewis/unitwise'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($RS)
  gem.test_files    = gem.files.grep(/^test\//)
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 2.6'

  gem.add_dependency               'liner',           '~> 0.2'
  gem.add_dependency               'signed_multiset', '~> 0.2'
  gem.add_dependency               'memoizable',      '~> 0.4'
  gem.add_dependency               'parslet',         '~> 2.0'

  gem.add_development_dependency   'nokogiri',        '~> 1.13'
  gem.add_development_dependency   'pry',             '~> 0.14'
  gem.add_development_dependency   'minitest',        '~> 5.15'
  gem.add_development_dependency   'rake',            '~> 13.0'
  gem.add_development_dependency   'nori',            '~> 2.6'
end
