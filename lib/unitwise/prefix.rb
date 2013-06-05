module Unitwise
  class Prefix < Base

    def self.data
      @data ||= YAML::load File.open(data_file)
    end

    def self.data_file
      Unitwise.data_file 'prefix'
    end

    def scale=(value)
      @scale = Scale.new.tap do |s|
        s.value = value
      end
    end

  end
end