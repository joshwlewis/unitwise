require 'spec_helper'

describe Unitwise::Measurement do
  subject { Unitwise::Measurement.new(1, 'm/s') }
  describe "#new" do
    it "should set attributes" do
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
  let(:kmh) { Unitwise::Measurement.new(100, 'km/h')}
  let(:mile) { Unitwise::Measurement.new(3, '[mi_i]')}
  let(:hpm) { Unitwise::Measurement.new(6, 'h/[mi_i]')}
  let(:cui) { Unitwise::Measurement.new(12, "[in_i]3")}

  describe "#scale" do
    it "must return value relative to terminal atoms" do
      subject.scale.must_equal 1
      mph.scale.must_equal 26.8224
    end
  end

  describe "#to" do
    it "should convert to a similar unit code" do
      mph.to('km/h').value.must_equal 96.56063999999999
    end
    it "should raise an error if the units aren't similar" do
      assert_raises(ArgumentError) { mph.to('N') }
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
      mult.unit.must_equal Unitwise::Unit.new("([mi_i]/h).([mi_i])")
    end

    it "must multiply canceling units" do
      mult = mph * hpm
      mult.value.must_equal 360
      mult.unit.to_s.must_equal "1"
    end
  end

  describe "#/" do
    it "should divide by scalars" do
      div = kmh / 4
      div.value.must_equal 25
      div.unit.must_equal kmh.unit
    end
    it "should divide by the value of similar units" do
      div = kmh / mph
      div.value.must_equal 1.03561865372889
      div.unit.to_s.must_equal '1'
    end
    it "should divide dissimilar units" do
      div = mph / hpm
      div.value.must_equal 10
      div.unit.to_s.must_equal "[mi_i]2/h2"
    end
  end

  describe "#+" do
    it "should add values when units are similar" do
      added = mph + kmh
      added.value.must_equal 122.13711922373341
      added.unit.must_equal mph.unit
    end
    it "should raise an error when units are not similar" do
      assert_raises(ArgumentError) { mph + hpm}
    end
  end

  describe "#-" do
    it "should add values when units are similar" do
      added = mph - kmh
      added.value.must_equal -2.1371192237334
      added.unit.must_equal mph.unit
    end
    it "should raise an error when units are not similar" do
      assert_raises(ArgumentError) { mph - hpm}
    end
  end

  describe "#**" do
    it "should raise to a power" do
      exp = mile ** 3
      exp.value.must_equal 27
      exp.unit.to_s.must_equal "[mi_i]3"
    end
    it "should raise to a negative power" do
      exp = mile ** -3
      exp.value.must_equal 0.037037037037037035
      exp.unit.to_s.must_equal "1/[mi_i]3"
    end
  end

end