require 'yaml'
module Unitwise
  class Base
    liner :names, :primary_code, :secondary_code, :symbol, :scale

    def self.all
      @all ||= data.map{|d| self.new d }
    end

    def self.find(string, method=:primary_code)
      self.all.find do |i|
        key = i.send(method)
        if key.respond_to?(:each)
          key.include?(string)
        else
          key == string
        end
      end
    end

    def names=(names)
      @names = Array(names)
    end

    def slugs
      names.map do |n|
        n.downcase.strip.gsub(/\s/, '_').gsub(/\W/, '')
      end
    end

    def to_s
      primary_code
    end

  end
end