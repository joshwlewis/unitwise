require 'spec_helper'

describe Unitwise::Atom do
  describe "class" do
    subject {Unitwise::Atom}
    describe :data do
      it "should have data" do
        subject.data.must_be_instance_of Array
      end
    end

    describe "all" do
      it "should be an Array of instances" do
        subject.all.must_be_instance_of Array
        subject.all.first.must_be_instance_of subject
      end
    end

    describe "find" do
      it "should find units" do
        subject.find("m").must_be_instance_of subject
        subject.find("V").must_be_instance_of subject
      end
    end
  end

  describe "instance" do
    subject {Unitwise::Atom.all.sample}
    describe :scale do
      it "should be a scale object" do
        subject.scale.must_be_instance_of Unitwise::Scale
      end
      it "should have a value" do
        subject.scale.value.must_be_kind_of Numeric
      end
    end
  end

end