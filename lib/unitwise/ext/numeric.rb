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
  # @example
  #   26.2.mile # => #<Unitwise::Measurement 26.2 mile>
  #   100.to_foot # => #<Unitwise::Measurement 100 foot>
  # @api semipublic
  def method_missing(meth, *args, &block)
    if args.empty? && !block_given?
      unit = (match = /\Ato_(\w+)\Z/.match(meth.to_s)) ? match[1] : meth
      begin
        res = convert_to(unit)
        Numeric.define_unit_conversion_methods_for(unit)
        res
      rescue Unitwise::ExpressionError
        super(meth, *args, &block)
      end
    else
      super(meth, *args, &block)
    end
  end

  protected

  def self.define_unit_conversion_methods_for(name)
    [name.to_sym, "to_#{ name }".to_sym].each do |meth|
      unless method_defined?(meth)
        define_method meth do
          convert_to(name)
        end
      end
    end
  end
end