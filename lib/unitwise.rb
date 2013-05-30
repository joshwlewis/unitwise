require "unitwise/version"
require "unitwise/base"
require "unitwise/derived_unit"
require "unitwise/base_unit"
require "unitwise/prefix"

module Unitwise

  def self.base_path
    @base_path ||= File.dirname(File.dirname(__FILE__))
  end

  def self.data_path
    @data_path ||= File.join base_path, "data"
  end

  def self.data_file(key)
    File.join data_path, "#{key}.yaml"
  end

end
