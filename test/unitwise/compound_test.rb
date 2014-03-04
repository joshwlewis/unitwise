require 'test_helper'

describe Unitwise::Compound do
  describe :class_methods do
    describe :all do
      subject { Unitwise::Compound.all }
      it { subject.must_be_kind_of Enumerable }
      it { subject.first.must_be_instance_of Unitwise::Compound }
    end
    describe :search do
      it "should return a list of units" do
        search = Unitwise::Compound.search('foo')
        search.must_be_kind_of Enumerable
        search.first.must_be_instance_of Unitwise::Compound
      end
    end
  end

  describe :instance_methods do
    let(:prefixed)   { Unitwise::Compound.new('m','k') }
    let(:unprefixed) { Unitwise::Compound.new("[in_i]") }
    it "should have an atom" do
      [prefixed, unprefixed].each { |ex| ex.atom.must_be_instance_of Unitwise::Atom }
    end
    it "should have a prefix when appropriate" do
      prefixed.prefix.must_be_instance_of Unitwise::Prefix
      unprefixed.prefix.must_equal nil
    end
    it "should concatenate common methods" do
      prefixed.primary_code.must_equal 'km'
      unprefixed.secondary_code.must_equal '[IN_I]'
      prefixed.names.must_equal ['kilometer']
      unprefixed.slugs.must_equal ['inch']
    end
    it "should have an array of strings for searching" do
      prefixed.search_strings.must_be_kind_of(Array)
    end
    it "should look ok for inspection" do
      prefixed.inspect.must_include 'km'
      unprefixed.inspect.must_include '[IN_I]'
    end
  end
end
