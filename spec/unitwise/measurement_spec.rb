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

  let(:other) { Unitwise::Measurement.new(4, '[mi_i]/h') }

  describe "#scale" do
    it "must return value relative to terminal atoms" do
      subject.scale.must_equal 1
      other.scale.must_equal 1.78816
    end
  end

  describe "#*" do
    it "must return a new measurement" do
      result = subject * other
      result.must_be_instance_of Unitwise::Measurement
      result.value.must_equal 4
      result.unit_code.must_equal "m/s.[mi_i]/h"
    end
  end

end