require 'yaml'
module Unitwise
  class Base
    attr_accessor :primary_code, :secondary_code, :symbol
    attr_reader :names, :measurement

    def self.all
      @all ||= data.map{|d| self.new d }
    end

    def self.find(string)
      self.all.find { |i| i.codes.include?(string) }
    end

    def initialize(attrs)
      attrs.each do |k, v|
        public_send :"#{k}=", v
      end
    end

    def names=(names)
      @names = Array(names)
    end

    def codes
      @codes ||= [primary_code, secondary_code].compact
    end


  end
end