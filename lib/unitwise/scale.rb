module Unitwise
  class Scale
    attr_accessor :value, :unit_code

    def unit
      @unit ||= Unit.new unit_code
    end

  end
end