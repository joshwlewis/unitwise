require 'spec_helper'

describe Unitwise::Unit::Prefix do
  subject { Unitwise::Unit::Prefix }
  describe "::data" do
    it "should be an Array" do
      subject.data.must_be_instance_of Array
    end
  end

  describe "::all" do
    it "should be an array of instances" do
      subject.all.must_be_instance_of Array
      assert subject.all.all?{|du| du.is_a?(subject)}
    end
  end

end