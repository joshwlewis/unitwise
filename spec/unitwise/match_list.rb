require 'spec_helper'

describe Unitwise::MatchList do
  describe "#create" do
    describe "::atom_codes" do
      subject { Unitwise::MatchList.atom_codes}
      it "must be an array of codes" do
        subject.must_be_instance_of String
        subject.must_include '|\\[in_us\\]|'
      end
    end
    describe "::metric_atom_codes" do
      subject { Unitwise::MatchList.metric_atom_codes}
      it "must be an array of codes" do
        subject.must_be_instance_of String
        subject.must_include '|N|'
      end
    end
    describe "::prefix_codes" do
      subject { Unitwise::MatchList.prefix_codes}
      it "must be an array of codes" do
        subject.must_be_instance_of String
        subject.must_include '|m|'
      end
    end
  end
end