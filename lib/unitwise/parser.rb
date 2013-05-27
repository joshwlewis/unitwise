require 'net/http'
require 'nori'
require 'unitwise/parser/item'
require 'unitwise/parser/prefix'
require 'unitwise/parser/base_unit'
require 'unitwise/parser/derived_unit'
require 'unitwise/parser/scale'
require 'unitwise/parser/function'

module Unitwise
  module Parser
    HOST = "unitsofmeasure.org"
    PATH = "/ucum-essence.xml"

    class << self
      def body
        @body ||= Net::HTTP.get HOST, PATH
      end

      def hash
        Nori.new.parse(body)["root"]
      end

    end
  end
end