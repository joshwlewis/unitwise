require 'yaml'
module Unitwise
  class Base
    attr_accessor :primary_code, :secondary_code, :symbol
    attr_reader :names, :scale

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

    def initialize(attrs)
      attrs.each do |k, v|
        public_send :"#{k}=", v
      end
    end

    def names=(names)
      @names = Array(names)
    end

    def slugs
      names.map(&:to_slug)
    end

  end
end