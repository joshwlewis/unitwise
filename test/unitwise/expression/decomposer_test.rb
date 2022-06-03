require 'test_helper'

describe Unitwise::Expression::Decomposer do
  subject { Unitwise::Expression::Decomposer }

  describe "#terms" do
    it "should accept codes" do
      fts = subject.new("[ft_i]/s").terms
      _(fts.count).must_equal 2
    end
    it "should accept names" do
      kms = subject.new("kilometer/second").terms
      _(kms.count).must_equal 2
    end
    it "should accept spaced names" do
      ncg = subject.new("Newtonian constant of gravitation").terms
      _(ncg.count).must_equal 1
    end
    it "should accept parameterized names" do
      pc = subject.new("planck_constant").terms
      _(pc.count).must_equal 1
    end
    it "should accept symbols" do
      saff = subject.new("<i>g<sub>n</sub></i>").terms
      _(saff.count).must_equal 1
    end
    it "should accept complex units" do
      complex = subject.new("(mg.(km/s)3/J)2.Pa").terms
      _(complex.count).must_equal 5
    end
    it "should accept more complex units" do
      complex = subject.new("4.1(mm/2s3)4.7.3J-2").terms
      _(complex.count).must_equal 3
    end
    it "should accept weird units" do
      frequency = subject.new("/s").terms
      _(frequency.count).must_equal 1
    end
    it "should accept units with a factor and unit" do
      oddity = subject.new("2ms2").terms
      _(oddity.count).must_equal 1
    end
  end

end
