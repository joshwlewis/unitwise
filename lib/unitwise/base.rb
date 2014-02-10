require 'yaml'
module Unitwise
  class Base
    liner :names, :primary_code, :secondary_code, :symbol, :scale

    def self.all
      @all ||= data.map{|d| self.new d }
    end

    def self.find(string)
      [:primary_code, :secondary_code, :names, :slugs, :symbol].reduce(nil) do |m, method|
        if found = find_by(method, string)
          return found
        end
      end
    end

    def self.find_by(method, string)
      self.all.find do |i|
        key = i.send(method)
        if key.respond_to?(:each)
          key.include?(string)
        else
          key == string
        end
      end
    end

    def self.search(term)
      self.all.select do |i|
        i.search_strings.any? { |string| string =~ /#{term}/i }
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

    def search_strings
      [primary_code, secondary_code, names, slugs, symbol].flatten.compact
    end

  end
end