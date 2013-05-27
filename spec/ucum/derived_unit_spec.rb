require 'spec_helper'
require 'ucum'

describe Ucum::DerivedUnit do
  it "should have data" do
    assert Ucum::DerivedUnit.data.is_a?(Array)
  end

  it "all should be an Array of instances" do
    assert Ucum::DerivedUnit.all.is_a?(Array)
    assert Ucum::DerivedUnit.all.all?{|du| du.is_a?(Ucum::DerivedUnit)}
  end

end