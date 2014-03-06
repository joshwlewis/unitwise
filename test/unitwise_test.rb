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

  describe 'search' do
    it "must return results" do
      Unitwise.search('foo').must_be_instance_of(Array)
    end
  end

  it "should have a path" do
    Unitwise.path.must_match(/unitwise$/)
  end

end
