require 'test_helper'

describe Unitwise do
  describe '()' do
    it "should accept a number and string" do
      Unitwise(2, 'm/s').must_be_instance_of Unitwise::Measurement
    end
    it "should accept a lonely string" do
      Unitwise('kg').must_be_instance_of Unitwise::Measurement
    end
  end
  it "should have a path" do
    Unitwise.path.must_match(/unitwise$/)
  end
end