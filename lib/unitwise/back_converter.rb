module Unitwise
  module BackConverter
    # A simple method to convert a Numeric to the least precise class
    # that still fully represents it's value
    # param number [Numeric] The number to convert
    # return [Numeric]
    def back_convert(number)
      number = BigDecimal(number.to_s) unless number.is_a?(Numeric)
      if number.is_a?(Integer)
        number
      elsif (i = Integer(number)) == number
        i
      elsif number.is_a?(Float)
        number
      elsif (f = Float(number)) == number
        f
      else
        number
      end
    end
  end
end
