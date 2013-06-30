require 'test_helper'

describe Numeric do

  describe "#to_unit" do
    it "must work for Integer" do
      measurement = 22.to_measurement("kg")
      measurement.must_be_instance_of(Unitwise::Measurement)
      measurement.value.must_equal 22
    end
    it "must work for Fixnum" do
      measurement = 24.25.to_measurement("[ft_i]")
      measurement.must_be_instance_of(Unitwise::Measurement)
      measurement.value.must_equal 24.25
    end
    it "must work for Float" do
      measurement = (22.0/7).to_measurement("[mi_i]")
      measurement.must_be_instance_of(Unitwise::Measurement)
      measurement.value.must_equal 3.142857142857143
    end
    it "must work for Rational" do
      measurement = Rational(22/7).to_measurement("N/m2")
      measurement.must_be_instance_of(Unitwise::Measurement)
      measurement.value.must_equal Rational(22/7)
    end
  end


end