require 'spec_helper'

require 'unitwise'

describe Unitwise do
  it "should have a base path" do
    Unitwise.base_path.must_match /unitwise$/
  end

  it "should have a data path" do
    Unitwise.data_path.must_match /unitwise\/data$/
  end

  it "should return the correct data file path" do
    Unitwise.data_file("funky").must_match /unitwise\/data\/funky.yaml$/
  end
end