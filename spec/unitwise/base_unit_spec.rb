require 'spec_helper'

describe Unitwise::BaseUnit do
  it "should have data" do
    assert Unitwise::BaseUnit.data.is_a?(Array)
  end

  it "all should be an Array of instances" do
    assert Unitwise::BaseUnit.all.is_a?(Array)
    assert Unitwise::BaseUnit.all.all?{|du| du.is_a?(Unitwise::BaseUnit)}
  end

  it "should find units" do
    assert Unitwise::BaseUnit.find("m").is_a?(Unitwise::BaseUnit)
  end

end