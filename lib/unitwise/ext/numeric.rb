class Numeric
  def convert(unit)
    Unitwise::Measurement.new(self, unit)
  end

  def method_missing(meth, *args, &block)
    if Unitwise::Expression.decompose(meth)
      self.convert(meth)
    else
      super(meth, *args, &block)
    end
  end
end