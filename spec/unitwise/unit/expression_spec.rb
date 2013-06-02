require 'spec_helper'

describe Unitwise::Unit::Expression do
    it "should handle basic units" do
      e = Unitwise::Unit::Expression.new "[ft_i]"
      e.atom.must_equal '[ft_i]'
      e.prefix.must_be_nil
      e.exponent.must_be_nil
      e.other_expression.must_be_nil
    end

  it "should handle prefixed units" do
    e = Unitwise::Unit::Expression.new "mm"
    e.atom.must_equal "m"
    e.prefix.must_equal "m"
    e.exponent.must_be_nil
    e.other_expression.must_be_nil
  end

  it "should handle units with exponents" do
    e = Unitwise::Unit::Expression.new "[in_i]3"
    e.atom.must_equal "[in_i]"
    e.prefix.must_be_nil
    e.exponent.must_equal '3'
    e.other_expression.must_be_nil
  end

  it "should handle multiple terms" do
    es = Unitwise::Unit::Expression.new("kN/cm2").expressions
    es.map(&:operator).must_equal ['/',nil]
    es.map(&:atom).must_equal ['N','m']
    es.map(&:prefix).must_equal ['k','c']
    es.map(&:exponent).must_equal [nil,'2']
  end
end