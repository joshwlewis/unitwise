class Numeric
  def to_measurement(unit)
    Unitwise::Measurement.new(self, unit)
  end
end