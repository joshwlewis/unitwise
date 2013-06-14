require 'spec_helper'

describe Unitwise::Expression do
  it "should handle basic units" do
    e = Unitwise::Expression.new "[ft_i]"
    e.atom.must_equal '[ft_i]'
    e.prefix.must_be_nil
    e.exponent.must_equal 1
    e.other_expression.must_be_nil
  end

  it "should handle prefixed units" do
    e = Unitwise::Expression.new "mm"
    e.atom.must_equal "m"
    e.prefix.must_equal "m"
    e.exponent.must_equal 1
    e.other_expression.must_be_nil
  end

  it "should handle units with exponents" do
    e = Unitwise::Expression.new("[in_i]3")
    e.atoms.must_equal ["[in_i]"]
    e.prefixes.must_equal [nil]
    e.exponents.must_equal [3]
  end

  it "should handle expressions with negative exponents" do
    e = Unitwise::Expression.new("N/m-2")
    e.atoms.must_equal ['N', 'm']
    e.exponents.must_equal [1, 2]
  end

  it "should handle divided units" do
    e = Unitwise::Expression.new("[mi_i]/h")
    e.atoms.must_equal(["[mi_i]","h"])
    e.prefixes.must_equal([nil,nil])
    e.exponents.must_equal([1,-1])
  end

  it "should handle divided units with exponents" do
    e = Unitwise::Expression.new("kN/cm2")
    e.atoms.must_equal ['N','m']
    e.prefixes.must_equal ['k','c']
    e.exponents.must_equal [1, -2]
  end

  it "should handle terms in parentheses" do
    es = Unitwise::Expression.new("(kJ)").expressions
    es.map(&:atom).must_equal(['J'])
    es.map(&:prefix).must_equal(['k'])
    es.map(&:exponent).must_equal([1])
  end

  it "should handle expressions in parentheses" do
    e = Unitwise::Expression.new "(N/s).([ft_i]/s2)"
    e.atoms.must_equal(['N','s','[ft_i]','s'])
    e.prefixes.must_equal([nil,nil,nil,nil])
    e.exponents.must_equal([1, -1, 1, -2])
  end

  it "should handle complicated expressions" do
    e = Unitwise::Expression.new "J.(km/s2)/(mm3.[in_i].[ft_i]/[mi_i]).kg-4"
    e.atoms.must_equal(['J','m','s','m','[in_i]','[ft_i]','[mi_i]','g'])
    e.exponents.must_equal([1,1,-2,-3,-1,-1,1,4])
    e.prefixes.must_equal([nil,'k',nil,'m',nil,nil,nil,'k'])
  end
end