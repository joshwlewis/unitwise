require 'test_helper'

describe Unitwise::Prefix do
  subject { Unitwise::Prefix }
  let(:m) { Unitwise::Prefix.find('m')}
  describe "::data" do
    it "should be an Array" do
      _(subject.data).must_be_instance_of Array
    end
  end

  describe "::all" do
    it "should be an array of prefixes" do
      _(subject.all).must_be_instance_of Array
      _(subject.all.first).must_be_instance_of Unitwise::Prefix
    end
  end

  describe "#scalar" do
    it "should be a number" do
      _(m.scalar).must_equal 0.001
    end
  end

end
