require 'test_helper'

describe Unitwise::Expression::Matcher do
  describe "::atom(:codes)" do
    subject { Unitwise::Expression::Matcher.atom(:codes)}
    it "must be an array of codes" do
      subject.must_be_instance_of Parslet::Atoms::Alternative
    end
  end
  describe "::metric_atom(:names)" do
    subject { Unitwise::Expression::Matcher.metric_atom(:names)}
    it "must be an array of names" do
      subject.must_be_instance_of Parslet::Atoms::Alternative
    end
  end
  describe "::prefix(:symbol)" do
    subject { Unitwise::Expression::Matcher.prefix(:symbol)}
    it "must be an array of symbols" do
      subject.must_be_instance_of Parslet::Atoms::Alternative
    end
  end
end