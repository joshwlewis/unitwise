require 'spec_helper'

require 'ucum'

describe Ucum::Item do
  it "should have a base path" do
    Ucum.base_path.must_match /ucum$/
  end

  it "should have a data path" do
    Ucum.data_path.must_match /ucum\/data$/
  end

  it "should return the right data file path" do
    Ucum.data_file("funky").must_match /ucum\/data\/funky.yaml$/
  end
end