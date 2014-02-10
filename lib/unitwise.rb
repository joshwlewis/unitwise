require 'liner'

require "unitwise/version"
require 'unitwise/base'
require 'unitwise/expression'
require 'unitwise/composable'
require 'unitwise/scale'
require 'unitwise/functional'
require 'unitwise/measurement'
require 'unitwise/atom'
require 'unitwise/prefix'
require 'unitwise/term'
require 'unitwise/unit'
require 'unitwise/function'
require 'unitwise/errors'

module Unitwise
  def self.path
    @path ||= File.dirname(File.dirname(__FILE__))
  end

  def self.data_file(key)
    File.join path, "data", "#{key}.yaml"
  end
end

def Unitwise(first_arg, last_arg=nil)
  if last_arg
    Unitwise::Measurement.new(first_arg, last_arg)
  else
    Unitwise::Measurement.new(1, first_arg)
  end
end

