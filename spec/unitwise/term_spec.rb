require 'spec_helper'

describe Unitwise::Term do
  describe "instance" do
    subject { Unitwise::Term.new(atom_code: 'J', prefix_code: 'k')}
    describe "#atom" do
      it "should be an atom" do
        subject.atom.must_be_instance_of Unitwise::Atom
      end
    end

    describe "#prefix" do
      it "should be a prefix" do
        subject.prefix.must_be_instance_of Unitwise::Prefix
      end
    end

    describe "#exponent" do
      it "should be an integer" do
        subject.exponent.must_equal 1
      end
    end

    describe "#root_terms" do
      it "should be an array of terms" do
        subject.root_terms.must_be_kind_of Array
        subject.root_terms.sample.must_be_instance_of Unitwise::Term
      end
    end

    describe "#composition" do
      it "should be a Multiset" do
        subject.composition.must_be_instance_of SignedMultiset
      end
    end
  end
end