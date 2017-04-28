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

  describe 'register' do
    it 'should allow custom units to be registered' do
      josh = {
        names: ["Josh W Lewis", "joshwlewis"],
        symbol: "JWL",
        primary_code: "jwl",
        secondary_code: "jwl",
        scale: {
          value: 71.875,
          unit_code: "[in_i]"
        }
      }

      Unitwise.register(josh)

      joshes = Unitwise(1, 'mile').to_jwl

      joshes.to_i.must_equal(881)
    end
  end

  it "should have a path" do
    Unitwise.path.must_match(/unitwise$/)
  end
end
