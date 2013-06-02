module Unitwise::Unit
  class Scale
    attr_accessor :value, :unit_code

    def compound
      Compound.find(unit_code)
    end

  end
end