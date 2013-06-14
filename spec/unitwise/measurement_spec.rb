require 'spec_helper'

describe Unitwise::Measurement do
  subject { Unitwise::Measurement.new(1, 'm/s') }
  describe "#new" do
    it "should set attributes" do
      subject.value.must_equal(1)
      subject.unit_code.must_equal('m/s')
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

  let(:mph) { Unitwise::Measurement.new(60, '[mi_i]/h') }
  let(:kmh) { Unitwise::Measurement.new(100, 'km/h')}
  let(:mile) { Unitwise::Measurement.new(3, '[mi_i]')}

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
      mult.unit_code.must_equal "[mi_i]/h"
    end
    it "must multiply similar units" do
      mult = mph * kmh
      mult.value.must_equal 3728.227153424004
      mult.unit_code.must_equal "([mi_i]/h)2"
    end
    it "must multiply unsimilar units" do
      mult = mph * mile
      mult.value.must_equal 180
      mult.unit_code.must_equal "([mi_i]/h).([mi_i])"
    end
  end

end