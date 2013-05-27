require 'net/http'
require 'nori'
require 'ucum/parser/item'
require 'ucum/parser/prefix'
require 'ucum/parser/base_unit'
require 'ucum/parser/unit'
require 'ucum/parser/scale'
require 'ucum/parser/function'
require 'ucum/parser/hash'

module Ucum
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