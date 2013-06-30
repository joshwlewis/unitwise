require "unitwise/version"
require 'unitwise/base'
require 'unitwise/expression'
require 'unitwise/composable'
require 'unitwise/measurement'
require 'unitwise/atom'
require 'unitwise/prefix'
require 'unitwise/term'
require 'unitwise/unit'
require 'unitwise/ext'

module Unitwise
  def self.path
    @path ||= File.dirname(File.dirname(__FILE__))
  end

  def self.data_file(key)
    File.join path, "data", "#{key}.yaml"
  end
end

