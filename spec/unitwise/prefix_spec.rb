require 'spec_helper'

describe Unitwise::Prefix do
  it "should have data" do
    assert Unitwise::Prefix.data.is_a?(Array)
  end

  it "all should be an Array of instances" do
    assert Unitwise::Prefix.all.is_a?(Array)
    assert Unitwise::Prefix.all.all?{|du| du.is_a?(Unitwise::Prefix)}
  end

end