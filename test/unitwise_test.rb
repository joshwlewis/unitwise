require 'test_helper'

describe Unitwise do
  describe '()' do
    it "should accept a number and string" do
      Unitwise(2, 'm/s').must_be_instance_of Unitwise::Measurement
    end
    it "should accept a measurement and a string" do
      mass = Unitwise(1, "lb")
      new_mass = Unitwise(mass, "kg")
      new_mass.value.must_equal(0.45359237)
      new_mass.unit.to_s.must_equal("kg")
    end
  end

  describe 'search' do
    it "must return results" do
      Unitwise.search('foo').must_be_instance_of(Array)
    end
  end

  describe 'valid?' do
    it 'should reutrn true for valid unit strings' do
      Unitwise.valid?('millimeter').must_equal true
    end
    it 'should return false for invalid unit strings' do
      Unitwise.valid?('foo').must_equal false
    end
  end

  it "should have a path" do
    Unitwise.path.must_match(/unitwise$/)
  end

end
