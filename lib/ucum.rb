require "ucum/version"
require "ucum/item"
require "ucum/derived_unit"

module Ucum

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
