require 'test_helper'

describe Unitwise do
  it "should have a path" do
    Unitwise.path.must_match /unitwise$/
  end
end