class Numeric
  def to_measurement(unit)
    Unitwise::Measurement.new(self, unit)
  end

  def method_missing(meth, *args, &block)
    if Unitwise::Expression.decompose(meth)
      Unitwise::Measurement.new(self, meth)
    else
      super(meth, *args, &block)
    end
  end
end