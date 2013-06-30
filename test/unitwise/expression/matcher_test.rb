require 'test_helper'

describe Unitwise::Expression::Matcher do
  describe "::atom_codes" do
    subject { Unitwise::Expression::Matcher.atom_codes}
    it "must be an array of codes" do
      subject.must_be_instance_of Parslet::Atoms::Alternative
    end
  end
  describe "::metric_atom_codes" do
    subject { Unitwise::Expression::Matcher.metric_atom_codes}
    it "must be an array of codes" do
      subject.must_be_instance_of Parslet::Atoms::Alternative
    end
  end
  describe "::prefix_codes" do
    subject { Unitwise::Expression::Matcher.prefix_codes}
    it "must be an array of codes" do
      subject.must_be_instance_of Parslet::Atoms::Alternative
    end
  end
end