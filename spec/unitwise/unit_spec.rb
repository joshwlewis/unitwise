require 'spec_helper'

describe Unitwise::Unit do

  subject { Unitwise::Unit.new("m/s2") }
  let(:other) { Unitwise::Unit.new("[psi]")}


  describe "#terms" do
    it "must be a collection of terms" do
      subject.must_respond_to :terms
      subject.terms.must_be_kind_of Enumerable
      subject.terms.sample.must_be_instance_of Unitwise::Term
    end
  end

  it "must have expressions" do
    subject.must_respond_to :expressions
    subject.expressions.must_be_kind_of Enumerable
    subject.expressions.sample.must_be_instance_of Unitwise::Expression
  end

  describe "#root_terms" do
    it "must be an array of Terms" do
      subject.must_respond_to :terms
      subject.root_terms.must_be_kind_of Array
      subject.root_terms.sample.must_be_instance_of Unitwise::Term
    end
  end

  describe "#scale" do
    it "must return value relative to terminal atoms" do
      subject.scale.must_equal 1
      other.scale.must_equal 6894757.293168359
    end
  end
  describe "#composition" do
    it "must be a multiset" do
      subject.must_respond_to :terms
      subject.composition.must_be_instance_of SignedMultiset
    end
  end

end