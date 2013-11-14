require 'test_helper'

describe Unitwise::Measurement do
  subject { Unitwise::Measurement.new(1, 'm/s') }
  describe "#new" do
    it "must set attributes" do
      subject.value.must_equal(1)
      subject.unit.to_s.must_equal('m/s')
    end
  end

  describe "#unit" do
    it "must be a unit" do
      subject.must_respond_to(:unit)
      subject.unit.must_be_instance_of(Unitwise::Unit)
    end
  end

  describe "#root_terms" do
    it "must be a collection of terms" do
      subject.must_respond_to(:root_terms)
      subject.root_terms.must_be_kind_of Enumerable
      subject.root_terms.sample.must_be_instance_of(Unitwise::Term)
    end
  end

  describe "#dup" do
    it "must return a new instance" do
      subject.must_respond_to(:dup)
      subject.dup.must_be_instance_of(Unitwise::Measurement)
      subject.dup.value.must_equal subject.value
      subject.dup.unit.to_s.must_equal subject.unit.to_s
      subject.dup.object_id.wont_equal subject.dup.object_id
    end
  end

  let(:mph) { Unitwise::Measurement.new(60, '[mi_i]/h') }
  let(:kmh) { Unitwise::Measurement.new(100, 'km/h') }
  let(:mile) { Unitwise::Measurement.new(3, '[mi_i]') }
  let(:hpm) { Unitwise::Measurement.new(6, 'h/[mi_i]') }
  let(:cui) { Unitwise::Measurement.new(12, "[in_i]3") }
  let(:cel) { Unitwise::Measurement.new(22, 'Cel') }
  let(:k) {Unitwise::Measurement.new(373.15, 'K') }
  let(:f) {Unitwise::Measurement.new(98.6, '[degF]')}
  let(:r) { Unitwise::Measurement.new(491.67, '[degR]') }

  describe "#scalar" do
    it "must return value relative to terminal atoms" do
      subject.scalar.must_equal 1
      mph.scalar.must_equal 26.8224
    end
  end

  describe "#convert" do
    it "must convert to a similar unit code" do
      mph.convert('km/h').value.must_equal 96.56063999999999
    end
    it "must raise an error if the units aren't similar" do
      ->{ mph.convert('N') }.must_raise Unitwise::ConversionError
    end
    it "must convert special units to their base units" do
      cel.convert('K').value.must_equal 295.15
    end
    it "must convert base units to special units" do
      k.convert('Cel').value.must_equal 100
    end
    it "must convert special units to special units" do
      f.convert('Cel').value.must_equal 37
    end
    it "must convert special units to non-special units" do
      cel.convert("[degR]").value.must_equal 531.27
    end
    it "must convert derived units to special units" do
      r.convert("Cel").value.round.must_equal 0
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
  end

  describe "#method_missing" do
    let(:meter) { Unitwise::Measurement.new(1, 'm')}
    it "must convert 'mm'" do
      convert = meter.mm
      convert.must_be_instance_of Unitwise::Measurement
      convert.value.must_equal 1000
    end

    it "must convert 'foot'" do
      convert = meter.foot
      convert.must_be_instance_of Unitwise::Measurement
      convert.value.must_equal 3.280839895013123
    end

    it "must not convert 'foo'" do
      ->{ meter.foo }.must_raise NoMethodError
    end

  end

end