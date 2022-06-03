require 'test_helper'

describe Unitwise::Term do
  describe "instance" do
    subject { Unitwise::Term.new(:atom => 'J', :prefix => 'k')}
    describe "#atom" do
      it "should be an atom" do
        _(subject.atom).must_be_instance_of Unitwise::Atom
      end
    end

    describe "#prefix" do
      it "should be a prefix" do
        _(subject.prefix).must_be_instance_of Unitwise::Prefix
      end
    end

    describe "#exponent" do
      it "should be an integer" do
        _(subject.exponent).must_equal 1
      end
    end

    describe "#root_terms" do
      it "should be an array of terms" do
        _(subject.root_terms).must_be_kind_of Array
        _(subject.root_terms.first).must_be_instance_of Unitwise::Term
      end
    end

    describe "#composition" do
      it "should be a Multiset" do
        _(subject.composition).must_be_instance_of SignedMultiset
      end
    end

    describe "#scale" do
      it "should return value relative to terminal atoms" do
        _(subject.scalar).must_equal 1000000.0
      end
    end

    describe "#frozen?" do
      it "should be frozen" do
        _(subject.frozen?).must_equal true
      end
    end

    describe "#to_s" do
      it "should return the UCUM code" do
        _(subject.to_s).must_equal "kJ"
      end
    end
  end
end
