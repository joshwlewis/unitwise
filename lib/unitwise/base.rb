require 'yaml'

module Unitwise
  class Base
    attr_accessor :names, :symbol, :primary_code, :secondary_code

    def self.all
      @all ||= data.map do |d|
        self.new d
      end
    end

    def self.data
      @data ||= YAML::load File.open(data_file)
    end

    def self.data_file
      @data_file ||= Unitwise.data_file(key)
    end

    def initialize(attrs)
      attrs.each do |k, v|
        self.send :"#{k}=", v
      end
    end

  end
end