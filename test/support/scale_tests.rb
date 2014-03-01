# Shared examples for Unitwise::Scale and Unitwise::Measurement
module ScaleTests
  def self.included(base)
    base.class_eval do
      subject { described_class.new(4, "J") }
      
      let(:mph)  { Unitwise::Measurement.new(60, '[mi_i]/h') }
      let(:kmh)  { Unitwise::Measurement.new(100, 'km/h') }
      let(:mile) { Unitwise::Measurement.new(3, '[mi_i]') }
      let(:hpm)  { Unitwise::Measurement.new(6, 'h/[mi_i]') }
      let(:cui)  { Unitwise::Measurement.new(12, "[in_i]3") }
      let(:cel)  { Unitwise::Measurement.new(22, 'Cel') }
      let(:k)    { Unitwise::Measurement.new(373.15, 'K') }
      let(:f)    { Unitwise::Measurement.new(98.6, '[degF]')}
      let(:r)    { Unitwise::Measurement.new(491.67, '[degR]') }

      describe "#new" do
        it "must set attributes" do
          subject.value.must_equal(4)
          subject.unit.to_s.must_equal('J')
        end
      end

      describe "#unit" do
        it "must be a unit" do
          subject.must_respond_to(:unit)
          subject.unit.must_be_instance_of(Unitwise::Unit)
        end
      end

      describe "#root_terms" do
        it "must be a collection of terms" do
          subject.must_respond_to(:root_terms)
          subject.root_terms.must_be_kind_of Enumerable
          subject.root_terms.sample.must_be_instance_of(Unitwise::Term)
        end
      end

      describe "#terms" do
        it "must return an array of terms" do
          subject.terms.must_be_kind_of(Enumerable)
          subject.terms.sample.must_be_kind_of(Unitwise::Term)
        end
      end
      
      describe "#atoms" do
        it "must return an array of atoms" do
          subject.atoms.must_be_kind_of(Enumerable)
          subject.atoms.sample.must_be_kind_of(Unitwise::Atom)
        end
      end

      describe "#scalar" do
        it "must return value relative to terminal atoms" do
          subject.scalar.must_equal 4000
          mph.scalar.must_equal 26.8224
        end
      end

      describe "#functional" do
        it "must return a converted value" do
          cel.functional(0,true).must_equal -273.15
        end
        it "must return a de-converted value" do
          cel.functional(0,false).must_equal 273.15
        end
      end

      describe "#special?" do
        it "must return true when unit is special, false otherwise" do
          subject.special?.must_equal false
          cel.special?.must_equal true
        end
      end

      describe "#depth" do
        it "must return a number indicating how far down the rabbit hole goes" do
          subject.depth.must_equal 11
          k.depth.must_equal 3
        end
      end

    end
  end
end
