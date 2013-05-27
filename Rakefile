require "bundler/gem_tasks"

require 'rake'
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "spec"
  t.pattern = 'spec/**/*_spec.rb'
end

task default: :test

namespace :unitwise do
  desc "Update Ucum Data"
  task :update_ucum do
    require 'unitwise'
    require 'unitwise/parser'
    Unitwise::Parser::BaseUnit.write
    Unitwise::Parser::DerivedUnit.write
    Unitwise::Parser::Prefix.write
  end
end
