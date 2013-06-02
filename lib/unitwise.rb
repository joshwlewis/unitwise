require "unitwise/version"
require "unitwise/unit"

module Unitwise
  def self.path
    @path ||= File.dirname(File.dirname(__FILE__))
  end

  def self.data_file(key)
    File.join path, "data", "#{key}.yaml"
  end
end
