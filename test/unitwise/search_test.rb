require 'test_helper'

describe Unitwise::Search do
  describe :class_methods do
    describe :all do
      subject { Unitwise::Search.all }
      it { _(subject).must_be_kind_of Enumerable }
      it { _(subject.first).must_be_instance_of Unitwise::Unit }
    end
    describe :search do
      it "should return a list of units" do
        search = Unitwise::Search.search('foo')
        _(search).must_be_kind_of Enumerable
        _(search.first).must_be_instance_of Unitwise::Unit
      end
    end
  end
end
