module Unitwise
  class Prefix < Base
    attr_reader :scale

    def self.data
      @data ||= YAML::load File.open(data_file)
    end

    def self.data_file
      Unitwise.data_file 'prefix'
    end

    def scale=(value)
      @scale = value.to_f
    end
  end
end