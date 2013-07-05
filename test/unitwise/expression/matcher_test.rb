require 'test_helper'

describe Unitwise::Expression::Matcher do
  describe "::atom(:codes)" do
    subject { Unitwise::Expression::Matcher.atom(:codes)}
    it "must be an Alternative list" do
      subject.must_be_instance_of Parslet::Atoms::Alternative
    end
    it "must parse [in_i]" do
      subject.parse("[in_i]").must_equal("[in_i]")
    end
  end
  describe "::metric_atom(:names)" do
    subject { Unitwise::Expression::Matcher.metric_atom(:names)}
    it "must be an Alternative list of names" do
      subject.must_be_instance_of Parslet::Atoms::Alternative
    end
    it "must parse 'Joule'" do
      ['joule', 'Joule'].each do |n|
        subject.parse(n).must_equal(n)
      end
    end
  end
  describe "::prefix(:symbol)" do
    subject { Unitwise::Expression::Matcher.prefix(:symbol)}
    it "must be an Alternative list of symbols" do
      subject.must_be_instance_of Parslet::Atoms::Alternative
    end
    it "must parse 'h'" do
      subject.parse('h').must_equal('h')
    end
  end
end