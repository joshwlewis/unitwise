require 'net/http'
require 'nori'
require 'unitwise/standard/base'
require 'unitwise/standard/prefix'
require 'unitwise/standard/base_unit'
require 'unitwise/standard/derived_unit'
require 'unitwise/standard/scale'
require 'unitwise/standard/function'

module Unitwise
  # The Standard module is responsible for fetching the UCUM specification unit
  # standards and translating them into yaml files. This code is only used for
  # by the rake task `rake unitwise:update_standard` and as such is not
  # normally loaded.
  module Standard
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
