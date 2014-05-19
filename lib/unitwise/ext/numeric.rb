class Numeric
  # Converts numeric to a measurement
  # @param unit [Unitwise::Unit, String] The unit to use in the measurement
  # @return [Unitwise::Measurement]
  # @example
  #   26.2.convert_to('mile') # => #<Unitwise::Measurement 1 mile>
  # @api public
  def convert_to(unit)
    Unitwise::Measurement.new(self, unit)
  end

  # Converts numeric to a measurement by the method name
  # @exmple
  #   26.2.mile # => #<Unitwise::Measurement 26.2 mile>
  #   100.to_foot # => #<Unitwise::Measurement 100 foot>
  # @api semipublic
  def method_missing(meth, *args, &block)
    if args.empty? && !block_given?
      unit = (match = /\Ato_(\w+)\Z/.match(meth.to_s)) ? match[1] : meth
      begin
        convert_to(unit)
      rescue Unitwise::ExpressionError
        super(meth, *args, &block)
      end
    else
      super(meth, *args, &block)
    end
  end
end