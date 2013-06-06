require 'spec_helper'

describe Unitwise::Term do
  describe "instance" do
    subject { Unitwise::Term.new(atom_code: 'J', prefix_code: 'k')}
    it "should have an atom" do
      subject.atom.must_be_instance_of Unitwise::Atom
    end
    it "should have a prefix" do
      subject.prefix.must_be_instance_of Unitwise::Prefix
    end
    it "should have an exponent" do
      subject.exponent.must_equal 1
    end
  end
end