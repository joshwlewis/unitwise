require 'test_helper'

describe Numeric do

  describe "#convert" do
    it "must work for Integer" do
      measurement = 22.convert("kg")
      measurement.must_be_instance_of(Unitwise::Measurement)
      measurement.value.must_equal 22
    end
    it "must work for Fixnum" do
      measurement = 24.25.convert("[ft_i]")
      measurement.must_be_instance_of(Unitwise::Measurement)
      measurement.value.must_equal 24.25
    end
    it "must work for Float" do
      measurement = (22.0/7).convert("[mi_i]")
      measurement.must_be_instance_of(Unitwise::Measurement)
      measurement.value.must_equal 3.142857142857143
    end
    it "must work for Rational" do
      measurement = Rational(22/7).convert("N/m2")
      measurement.must_be_instance_of(Unitwise::Measurement)
      measurement.value.must_equal Rational(22/7)
    end
  end

  describe "#method_missing" do
    it "must match mm" do
      mm = 2.5.mm
      mm.must_be_instance_of(Unitwise::Measurement)
      mm.value.must_equal 2.5
    end
    it "must match foot" do
      ft = 4.foot
      ft.must_be_instance_of(Unitwise::Measurement)
      ft.value.must_equal 4
    end
    it "must not match 'foo'" do
      ->{ 1.foo }.must_raise NoMethodError
    end

  end


end