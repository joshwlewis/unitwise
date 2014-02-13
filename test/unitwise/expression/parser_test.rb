require 'test_helper'

describe Unitwise::Expression::Parser do
  subject { Unitwise::Expression::Parser.new}
  describe '#metric_atom' do
    it "must match 'N'" do
      subject.metric_atom.parse('N')[:atom_code].must_equal('N')
    end
  end

  describe '#atom' do
    it "must match '[in_i]'" do
      subject.atom.parse('[in_i]')[:atom_code].must_equal('[in_i]')
    end
  end

  describe '#prefix' do
    it "must match 'k'" do
      subject.prefix.parse('k')[:prefix_code].must_equal('k')
    end
  end

  describe '#annotation' do
    it "must match '{foobar}'" do
      subject.annotation.parse('{foobar}')[:annotation].must_equal('foobar')
    end
  end

  describe "#factor" do
    it "must match positives and fixnums" do
      subject.factor.parse('3.2')[:factor].must_equal(fixnum: '3.2')
    end
    it "must match negatives and integers" do
      subject.factor.parse('-5')[:factor].must_equal(integer: '-5')
    end
  end

  describe "#exponent" do
    it "must match positives integers" do
      subject.exponent.parse('4')[:exponent].must_equal(integer: '4')
    end
    it "must match negative integers" do
      subject.exponent.parse('-5')[:exponent].must_equal(integer: '-5')
    end
  end

  describe "term" do
    it "must match basic atoms" do
      subject.term.parse('[in_i]')[:term][:atom][:atom_code].must_equal('[in_i]')
    end
    it "must match prefixed atoms" do
      match = subject.term.parse('ks')[:term]
      match[:atom][:atom_code].must_equal('s')
      match[:prefix][:prefix_code].must_equal('k')
    end
    it "must match exponential atoms" do
      match = subject.term.parse('cm3')[:term]
      match[:atom][:atom_code].must_equal 'm'
      match[:prefix][:prefix_code].must_equal 'c'
      match[:exponent][:integer].must_equal '3'
    end
    it "must match factors" do
      subject.term.parse('3.2')[:term][:factor][:fixnum].must_equal '3.2'
    end
    it "must match annotations" do
      match = subject.term.parse('N{Normal}')[:term]
      match[:atom][:atom_code].must_equal 'N'
      match[:annotation].must_equal 'Normal'
    end
  end

  describe '#group' do
    it "must match parentheses with a term" do
      match = subject.group.parse('(s2)')[:group][:nested][:left][:term]
      match[:atom][:atom_code].must_equal 's'
      match[:exponent][:integer].must_equal '2'
    end
    it "must match nested groups" do
      match = subject.group.parse('((kg))')[:group][:nested][:left][:group][:nested][:left][:term]
      match[:atom][:atom_code].must_equal 'g'
      match[:prefix][:prefix_code].must_equal 'k'
    end
    it "must pass exponents down" do
      match = subject.group.parse('([in_i])3')[:group]
      match[:exponent][:integer].must_equal '3'
      match[:nested][:left][:term][:atom][:atom_code].must_equal '[in_i]'
    end
  end

  describe "#expression" do
    it "must match left only" do
      match = subject.expression.parse('m')
      match[:left][:term][:atom][:atom_code].must_equal("m")
    end
    it "must match left + right + operator" do
      match = subject.expression.parse('m.s')
      match[:left][:term][:atom][:atom_code].must_equal("m")
      match[:operator].must_equal('.')
      match[:right][:left][:term][:atom][:atom_code].must_equal('s')
    end
    it "must match operator + right" do
      match = subject.expression.parse("/s")
      match[:operator].must_equal('/')
      match[:right][:left][:term][:atom][:atom_code].must_equal('s')
    end
  end


end