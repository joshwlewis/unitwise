require 'spec_helper'

describe Unitwise::CodeList do
  describe "#create" do
    subject { Unitwise::CodeList.create Unitwise::Atom.all.sample(10) }
    it "must be a collection of strings" do
      subject.must_be_kind_of Enumerable
      subject.sample.must_be_instance_of String
    end
  end
end