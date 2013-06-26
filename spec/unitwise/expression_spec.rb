require 'spec_helper'

describe Unitwise::Expression do
  subject { Unitwise::Expression }
  describe '#metric_atom' do
    it "must match 'N'" do
      match = subject.parse('N', root: :metric_atom)
      match.value.must_be_instance_of(Unitwise::Atom)
    end
  end

  describe '#atom' do
    it "must match '[in_i]'" do
      match = subject.parse('[in_i]', root: :atom)
      match.value.must_be_instance_of(Unitwise::Atom)
    end
  end

  describe '#prefix' do
    it "must match 'k'" do
      match = subject.parse('k', root: :prefix)
      match.value.must_be_instance_of(Unitwise::Prefix)
    end
  end

  describe '#annotation' do
    it "must match '{foobar}'" do
      match = subject.parse('{foobar}', root: :annotation)
      match.value.must_equal 'foobar'
    end
  end

  describe "#factor" do
    it "must match positives and floats" do
      match = subject.parse('3.2', root: :factor)
      match.value.must_equal 3.2
    end
    it "must match negatives and integers" do
      match = subject.parse('-5', root: :factor)
      match.value.must_equal -5
    end
  end

  describe "#exponent" do
    it "must match positive integers" do
      match = subject.parse('4', root: :exponent)
      match.value.must_equal 4
    end
    it "must match negative integers" do
      match = subject.parse('-2', root: :exponent)
      match.value.must_equal -2
    end
  end

  describe "term" do
    it "must match basic atoms" do
      match = subject.parse('[in_i]', root: :term)
      match.atom.must_equal '[in_i]'
      match.value.must_be_instance_of Unitwise::Term
    end
    it "must match prefixed atoms" do
      match = subject.parse('ks', root: :term)
      match.atom.must_equal 's'
      match.prefix.must_equal 'k'
      match.value.must_be_instance_of Unitwise::Term
    end
    it "must match exponentail atoms" do
      match = subject.parse('cm3', root: :term)
      match.atom.must_equal 'm'
      match.prefix.must_equal 'c'
      match.exponent.value.must_equal 3
      match.value.must_be_instance_of Unitwise::Term
    end
    it "must match factors" do
      match = subject.parse('3.2', root: :term)
      match.factor.value.must_equal 3.2
      match.value.must_be_instance_of Unitwise::Term
    end
    it "must match annotations" do
      match = subject.parse('N{Normal}', root: :term)
      match.atom.must_equal 'N'
      match.annotation.value.must_equal 'Normal'
      match.value.must_be_instance_of Unitwise::Term
    end
  end

  describe '#group' do
    it "must match parentheses with a term" do
      match = subject.parse('(s2)', root: :group)
      match.value.must_be_instance_of Array
      match.value.first.must_be_instance_of Unitwise::Term
      match.value.first.atom.primary_code.must_equal 's'
      match.value.first.exponent.must_equal 2
    end
    it "must match nested groups" do
      match = subject.parse('(((kg)))', root: :group)
      match.value.must_be_instance_of Array
      match.value.first.atom.primary_code.must_equal 'g'
      match.value.first.prefix.primary_code.must_equal 'k'
    end
    it "must pass exponents down" do
      match = subject.parse('([in_i])3', root: :group)
      match.value.must_be_instance_of Array
      match.value.first.atom.primary_code.must_equal '[in_i]'
      match.value.first.exponent.must_equal 3
    end
  end


end