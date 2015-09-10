# Unitwise extends Numeric to add these dyanmic method conveniences: `1.meter`,
# `26.2.to_mile`, and `4.convert_to("Joule")`. These overrides are optional
# and may be enabled with `require 'unitwise/ext'`. These methods are known to
# reduce performance, as well as violate Ruby best practices. They are
# deprecated and will be removed in a future version.
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
      converted = begin
        convert_to(unit)
      rescue Unitwise::ExpressionError
        nil
      end
    end
    if converted
      Numeric.define_unit_conversion_methods_for(unit)
      converted
    else
      super(meth, *args, &block)
    end
  end

  def self.define_unit_conversion_methods_for(name)
    [name.to_sym, "to_#{ name }".to_sym].each do |meth|
      next if method_defined?(meth)
      define_method meth do
        convert_to(name)
      end
    end
  end
end
