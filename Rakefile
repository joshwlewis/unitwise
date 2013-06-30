require "bundler/gem_tasks"

require 'rake'
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
end

task default: :test

namespace :unitwise do
  desc "Update Ucum Data"
  task :update_standard do
    require 'unitwise'
    require 'unitwise/standard'
    Unitwise::Standard::BaseUnit.write
    Unitwise::Standard::DerivedUnit.write
    Unitwise::Standard::Prefix.write
  end
end
