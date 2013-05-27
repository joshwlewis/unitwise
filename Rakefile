require "bundler/gem_tasks"

require 'rake'
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "spec"
  t.pattern = 'spec/**/*_spec.rb'
end

task default: :test
