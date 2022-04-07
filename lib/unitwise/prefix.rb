module Unitwise
  # A prefix can be used with metric atoms to modify their scale.
  class Prefix < Base
    liner :scalar

    # The data loaded from the UCUM spec files
    # @api semipublic
    def self.data
      f = File.open(data_file)
      @data ||= ::YAML.respond_to?(:unsafe_load) ? ::YAML.unsafe_load(f) : ::YAML.load(f)
    end

    # The location of the UCUM spec prefix data file
    # @api semipublic
    def self.data_file
      Unitwise.data_file 'prefix'
    end
  end
end
