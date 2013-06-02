require 'yaml'
module Unitwise::Unit
  class Base
    attr_accessor :names, :symbol, :primary_code, :secondary_code, :scale

    def self.all
      @all ||= data.map do |d|
        self.new d
      end
    end

    def self.find(string)
      [:primary_code, :secondary_code, :symbol].map do |m|
        self.all.find { |u| u.send(m) == string}
      end.first
    end

    def initialize(attrs)
      attrs.each do |k, v|
        self.send :"#{k}=", v
      end
    end

    def codes
      [primary_code, secondary_code]
    end

  end
end