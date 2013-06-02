require "unitwise/version"
require 'unitwise/base'
require 'unitwise/scale'
require 'unitwise/atom'
require 'unitwise/prefix'
require 'unitwise/term'
require 'unitwise/unit'
require 'unitwise/expression'

module Unitwise
  def self.path
    @path ||= File.dirname(File.dirname(__FILE__))
  end

  def self.data_file(key)
    File.join path, "data", "#{key}.yaml"
  end
end
