require 'test_helper'
require 'support/scale_tests'

describe Unitwise::Measurement do
  let(:described_class) { Unitwise::Measurement }
  include ScaleTests

  describe "#new" do
    it "should raise an error for unknown units" do
      lambda { Unitwise::Measurement.new(1,"funkitron") }.must_raise(Unitwise::ExpressionError)
    end
  end

  describe "#convert_to" do
    it "must convert to a similar unit code" do
      mph.convert_to('km/h').value.must_equal 96.56063999999999
    end
    it "must raise an error if the units aren't similar" do
      lambda { mph.convert_to('N') }.must_raise Unitwise::ConversionError
    end
    it "must convert special units to their base units" do
      cel.convert_to('K').value.must_equal 295.15
    end
    it "must convert base units to special units" do
      k.convert_to('Cel').value.must_equal 100
    end
    it "must convert special units to special units" do
      f.convert_to('Cel').value.must_equal 37
    end
    it "must convert special units to non-special units" do
      cel.convert_to("[degR]").value.must_equal 531.27
    end
    it "must convert derived units to special units" do
      r.convert_to("Cel").value.round.must_equal 0
    end
  end

  describe "#*" do
    it "must multiply by scalars" do
      mult = mph * 4
      mult.value.must_equal 240
      mult.unit.must_equal Unitwise::Unit.new("[mi_i]/h")
    end
    it "must multiply similar units" do
      mult = mph * kmh
      mult.value.must_equal 3728.227153424004
      mult.unit.must_equal Unitwise::Unit.new("([mi_i]/h).([mi_i]/h)")
    end
    it "must multiply unsimilar units" do
      mult = mph * mile
      mult.value.must_equal 180
      mult.unit.must_equal Unitwise::Unit.new("[mi_i]2/h")
    end
    it "must multiply canceling units" do
      mult = mph * hpm
      mult.value.must_equal 360
      mult.unit.to_s.must_equal "1"
    end
  end

  describe "#/" do
    it "must divide by scalars" do
      div = kmh / 4
      div.value.must_equal 25
      div.unit.must_equal kmh.unit
    end
    it "must divide by the value of similar units" do
      div = kmh / mph
      div.value.must_equal 1.03561865372889
      div.unit.to_s.must_equal '1'
    end
    it "must divide dissimilar units" do
      div = mph / hpm
      div.value.must_equal 10
      div.unit.to_s.must_equal "[mi_i]2/h2"
    end
  end

  describe "#+" do
    it "must add values when units are similar" do
      added = mph + kmh
      added.value.must_equal 122.13711922373341
      added.unit.must_equal mph.unit
    end
    it "must raise an error when units are not similar" do
      assert_raises(TypeError) { mph + hpm}
    end
  end

  describe "#-" do
    it "must add values when units are similar" do
      added = mph - kmh
      added.value.must_equal -2.1371192237334
      added.unit.must_equal mph.unit
    end
    it "must raise an error when units are not similar" do
      assert_raises(TypeError) { mph - hpm}
    end
  end

  describe "#**" do
    it "must raise to a power" do
      exp = mile ** 3
      exp.value.must_equal 27
      exp.unit.to_s.must_equal "[mi_i]3"
    end
    it "must raise to a negative power" do
      exp = mile ** -3
      exp.value.must_equal 0.037037037037037035
      exp.unit.to_s.must_equal "1/[mi_i]3"
    end
    it "must not raise to a weird power" do
      lambda { mile ** 'weird' }.must_raise TypeError
    end
  end

  describe "#coerce" do
    let(:meter) { Unitwise::Measurement.new(1, 'm') }
    it "must coerce numerics" do
      (5 * meter).must_equal Unitwise::Measurement.new(5, 'm')
    end
    it "should raise an error for other crap" do
      lambda { meter.coerce("foo") }.must_raise TypeError
    end
  end

  describe "equality" do
    let(:m)    { Unitwise::Measurement.new(1,'m') }
    let(:mm)   { Unitwise::Measurement.new(1000,'mm') }
    let(:foot) { Unitwise::Measurement.new(1,'foot') }
    let(:g)    { Unitwise::Measurement.new(1,'gram') }
    it "should be ==" do
      assert m == m
      assert m == mm
      refute m == foot
      refute m == g
    end
    it "should be ===" do
      assert m == m
      assert m === mm
      refute m === foot
      refute m == g
    end
    it "should be equal?" do
      assert m.equal?(m)
      refute m.equal?(mm)
      refute m.equal?(foot)
      refute m.equal?(g)
    end
    it "should be eql?" do
      assert m.eql?(m)
      refute m.equal?(mm)
      refute m.equal?(foot)
      refute m.equal?(g)
    end
  end

  describe "#method_missing" do
    let(:meter) { Unitwise::Measurement.new(1, 'm')}
    it "must convert 'to_mm'" do
      convert = meter.to_mm
      convert.must_be_instance_of Unitwise::Measurement
      convert.value.must_equal 1000
    end

    it "must convert 'to_foot'" do
      convert = meter.to_foot
      convert.must_be_instance_of Unitwise::Measurement
      convert.value.must_equal 3.280839895013123
    end

    it "must not convert 'foo'" do
      lambda { meter.foo }.must_raise NoMethodError
    end

    it "must not convert 'to_foo'" do
      lambda { meter.to_foo }.must_raise NoMethodError
    end

  end

  describe "#to_f" do
    it "must convert to a float" do
      f.to_f.must_be_kind_of(Float)
    end
  end

  describe "#to_i" do
    it "must convert to an integer" do
      k.to_i.must_be_kind_of(Integer)
    end
  end

  describe "#to_r" do
    it "must convert to a rational" do
      cel.to_r.must_be_kind_of(Rational)
    end
  end

end