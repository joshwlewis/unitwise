source 'https://rubygems.org'

if RUBY_VERSION > '1.8.7'
  # https://bugs.ruby-lang.org/issues/9316
  gem 'bigdecimal', '~> 1.2.4', :platform => :mri
  # Coveralls doesn't run on 1.8.7, but we only need it for testing.
  gem 'coveralls',  '~> 0.7'
end

gemspec
