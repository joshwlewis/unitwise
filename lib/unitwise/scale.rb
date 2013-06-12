module Unitwise
  class Scale
    attr_accessor :value, :unit_code

    include Unitwise::Composable

    def unit
      @unit ||= Unit.new unit_code
    end

    def root_terms
      unit.root_terms
    end

  end
end