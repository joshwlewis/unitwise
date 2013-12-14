class Numeric
  def convert(unit)
    Unitwise::Measurement.new(self, unit)
  end

  def method_missing(meth, *args, &block)
    convert(meth)
  rescue Unitwise::ExpressionError
    super(meth, *args)
  end
end