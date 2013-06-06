require 'spec_helper'

describe Unitwise::Unit do

  describe "instance" do
    subject { Unitwise::Unit.new("m/s2") }

    it "should have terms" do
      subject.must_respond_to :terms
      subject.terms.must_be_kind_of Enumerable
      subject.terms.sample.must_be_instance_of Unitwise::Term
    end

    it "should have expressions" do
      subject.must_respond_to :expressions
      subject.expressions.must_be_kind_of Enumerable
      subject.expressions.sample.must_be_instance_of Unitwise::Expression
    end

  end
end