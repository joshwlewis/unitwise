require 'test_helper'

describe Unitwise::Function do
  subject { Unitwise::Function }

  it '::all must be an Array' do
    subject.all.must_be_instance_of Array
  end

  it '::add must add to :all' do
    defined = subject.add('foo(2 3N)', ->{ 4 }, ->{ 6 })
    subject.all.must_include(defined)
  end

  it "::find must find by name" do
    defined = subject.add("foo", -> { 3 }, -> { 7 })
    subject.find("foo").must_equal(defined)
  end

  let (:fp) { Unitwise::Function.new('foo(1 4J)', ->(x){ x + 1}, ->(x){ x - 1 }) }

  it 'must have a #name' do
    fp.name.must_equal('foo(1 4J)')
  end

  it 'must have a direct lambda' do
    fp.direct.call(1).must_equal 2
  end

  it 'must have a inverse lambda' do
    fp.inverse.call(1).must_equal 0
  end

  it 'must have a direct_scalar' do
    fp.direct_scalar(1).must_equal 2
  end

  it 'must have an inverse scalar' do
    fp.inverse_scalar(1).must_equal 0
  end

end