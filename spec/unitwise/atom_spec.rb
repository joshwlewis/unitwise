require 'spec_helper'

describe Unitwise::Atom do
  subject { Unitwise::Atom }
  describe "::data" do
    it "must have data" do
      subject.data.must_be_instance_of Array
      subject.data.count.must_be :>, 0
    end
  end

  describe "::all" do
    it "must be an Array of instances" do
      subject.all.must_be_instance_of Array
      subject.all.first.must_be_instance_of Unitwise::Atom
    end
  end

  describe "::find" do
    it "must find atoms" do
      subject.find("m").must_be_instance_of Unitwise::Atom
      subject.find("V").must_be_instance_of Unitwise::Atom
    end
  end

  let(:second) { Unitwise::Atom.find("s") }
  let(:yard) { Unitwise::Atom.find("[yd_i]")}
  let(:pi) { Unitwise::Atom.find("[pi]")}
  let(:celsius) { Unitwise::Atom.find("Cel")}
  let(:pfu) { Unitwise::Atom.find("[PFU]")}
  describe "#measurement" do
    it "must be nil for base atoms" do
      second.measurement.must_equal nil
    end
    it "sould be a measurement object for derived atoms" do
      yard.measurement.must_be_instance_of Unitwise::Measurement
    end
  end

  describe "#base?" do
    it "must be true for base atoms" do
      second.base?.must_equal true
    end
    it "must be false for derived atoms" do
      yard.base?.must_equal false
      pi.base?.must_equal false
    end
  end

  describe "#derived?" do
    it "must be false for base atoms" do
      second.derived?.must_equal false
    end
    it "must be true for derived atoms" do
      yard.derived?.must_equal true
      celsius.derived?.must_equal true
    end
  end

  describe "#metric?" do
    it "must be true for base atoms" do
      second.metric?.must_equal true
    end
    it "must be false for english atoms" do
      yard.metric?.must_equal false
    end
  end

  describe "#special?" do
    it "must be true for special atoms" do
      celsius.special.must_equal true
    end
    it "must be false for non-special atoms" do
      second.special?.must_equal false
    end
  end

  describe "#arbitrary?" do
    it "must be true for arbitrary atoms" do
      pfu.arbitrary?.must_equal true
    end
    it "must be false for non-arbitrary atoms" do
      yard.arbitrary?.must_equal false
      celsius.arbitrary?.must_equal false
    end
  end

  describe "#dimless?" do
    it "must be true for dimless atoms" do
      pi.dimless?.must_equal true
    end
    it "must be false for dimension atoms" do
      second.dimless?.must_equal false
      yard.dimless?.must_equal false
    end
  end

  describe "#root?" do
    it "must be true for root atoms" do
      second.root?.must_equal true
      pi.root?.must_equal true
    end
    it "must be false for non-root atoms" do
      yard.root?.must_equal false
      celsius.root?.must_equal false
    end
  end

  describe "#key" do
    it "must return the dim or the property" do
      second.key.must_equal "T"
      pi.key.must_equal "number"
      celsius.key.must_equal "temperature"
    end
  end

  describe "#measurement=" do
    it "must create a new measurement object and set attributes" do
      skip("need to figure out mocking and stubbing with minitest")
    end
  end
end