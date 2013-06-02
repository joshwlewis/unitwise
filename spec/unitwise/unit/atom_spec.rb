require 'spec_helper'

describe Unitwise::Unit::Atom do
  subject {Unitwise::Unit::Atom}
  describe "::data" do
    it "should have data" do
      subject.data.must_be_instance_of Array
    end
  end

  describe "::all" do
    it "should be an Array of instances" do
      subject.all.must_be_instance_of Array
      subject.all.first.must_be_instance_of subject
    end
  end

  describe "::find" do
    it "should find units" do
      subject.find("m").must_be_instance_of subject
      subject.find("V").must_be_instance_of subject
    end
  end

end