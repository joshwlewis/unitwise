require 'test_helper'

describe Unitwise::Prefix do
  subject { Unitwise::Prefix }
  let(:m) { Unitwise::Prefix.find('m')}
  describe "::data" do
    it "should be an Array" do
      subject.data.must_be_instance_of Array
    end
  end

  describe "::all" do
    it "should be an array of prefixes" do
      subject.all.must_be_instance_of Array
      subject.all.sample.must_be_instance_of Unitwise::Prefix
    end
  end

  describe "#scale" do
    it "should be a number" do
      m.scale.must_equal 0.001
    end
  end

end