require 'spec_helper'

describe Unitwise::DerivedUnit do
  it "should have data" do
    assert Unitwise::DerivedUnit.data.is_a?(Array)
  end

  it "all should be an Array of instances" do
    assert Unitwise::DerivedUnit.all.is_a?(Array)
    assert Unitwise::DerivedUnit.all.all?{|du| du.is_a?(Unitwise::DerivedUnit)}
  end

end