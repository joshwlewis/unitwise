# frozen_string_literal: true

require 'test_helper'

describe Unitwise::Expression::Decomposer do
  subject { Unitwise::Expression::Decomposer }

  describe '#terms' do
    it 'should accept codes' do
      fts = subject.new('[ft_i]/s').terms
      fts.count.must_equal 2
    end

    it 'should accept names' do
      kms = subject.new('kilometer/second').terms
      kms.count.must_equal 2
    end

    it 'should accept spaced names' do
      ncg = subject.new('Newtonian constant of gravitation').terms
      ncg.count.must_equal 1
    end

    it 'should accept parameterized names' do
      pc = subject.new('planck_constant').terms
      pc.count.must_equal 1
    end

    it 'should accept symbols' do
      saff = subject.new('<i>g<sub>n</sub></i>').terms
      saff.count.must_equal 1
    end

    it 'should accept exact symbol match over prefixed matches' do
      ft = subject.new('ft').terms
      ft.count.must_equal 1
      ft.first.atom.primary_code.must_equal '[ft_i]'
    end

    it 'should accept prefixed units' do
      kg = subject.new('kg').terms
      kg.count.must_equal 1
      kg.first.prefix.primary_code.must_equal 'k'
    end

    it 'should accept complex units' do
      complex = subject.new('(mg.(km/s)3/J)2.Pa').terms
      complex.count.must_equal 5
    end

    it 'should accept complex units with symbol match over prefixed match' do
      complex = subject.new('((ft/s)3/J)2.Pa').terms
      complex.count.must_equal 4
      complex.first.atom.primary_code.must_equal '[ft_i]'
    end

    it 'should accept more complex units' do
      complex = subject.new('4.1(mm/2s3)4.7.3J-2').terms
      complex.count.must_equal 3
    end

    it 'should accept weird units' do
      frequency = subject.new('/s').terms
      frequency.count.must_equal 1
    end

    it 'should accept weird exact symbol match units over prefixed match' do
      per_foot = subject.new('/ft').terms
      per_foot.count.must_equal 1
      per_foot.first.atom.primary_code.must_equal '[ft_i]'
    end

    it 'should accept units with a factor and unit' do
      oddity = subject.new('2ms2').terms
      oddity.count.must_equal 1
    end
  end
end
