require 'test_helper'

describe Unitwise::Expression::Decomposer do
  subject { Unitwise::Expression::Decomposer }

  describe "PARSERS" do
    it "should return multiple parsers" do
      subject::PARSERS.must_be_instance_of Array
      subject::PARSERS.sample.must_be_instance_of Unitwise::Expression::Parser
    end
  end

  describe "#terms" do
    it "should accept codes" do
      fts = subject.new("[ft_i]/s").terms
      fts.count.must_equal 2
    end
    it "should accept names" do
      kms = subject.new("kilometer/second").terms
      kms.count.must_equal 2
    end
    it "should accept spaced names" do
      ncg = subject.new("Newtonian constant of gravitation").terms
      ncg.count.must_equal 1
    end
    it "should accept parameterized names" do
      pc = subject.new("planck_constant").terms
      pc.count.must_equal 1
    end
    it "should accept symbols" do
      saff = subject.new("<i>g<sub>n</sub></i>").terms
      saff.count.must_equal 1
    end
  end

end