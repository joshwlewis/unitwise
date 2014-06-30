# Shared examples for Unitwise::Scale and Unitwise::Measurement
module ScaleTests
  def self.included(base)
    base.class_eval do
      subject { described_class.new(4, "J") }

      let(:mph)  { described_class.new(60, '[mi_i]/h') }
      let(:kmh)  { described_class.new(100, 'km/h') }
      let(:mile) { described_class.new(3, '[mi_i]') }
      let(:hpm)  { described_class.new(6, 'h/[mi_i]') }
      let(:cui)  { described_class.new(12, "[in_i]3") }
      let(:cel)  { described_class.new(22, 'Cel') }
      let(:k)    { described_class.new(373.15, 'K') }
      let(:f)    { described_class.new(98.6, '[degF]')}
      let(:r)    { described_class.new(491.67, '[degR]') }

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
          subject.root_terms.first.must_be_instance_of(Unitwise::Term)
        end
      end

      describe "#terms" do
        it "must return an array of terms" do
          subject.terms.must_be_kind_of(Enumerable)
          subject.terms.first.must_be_kind_of(Unitwise::Term)
        end
      end

      describe "#atoms" do
        it "must return an array of atoms" do
          subject.atoms.must_be_kind_of(Enumerable)
          subject.atoms.first.must_be_kind_of(Unitwise::Atom)
        end
      end

      describe "#scalar" do
        it "must return value relative to terminal atoms" do
          subject.scalar.must_equal 4000
          mph.scalar.must_almost_equal 26.8224
          cel.scalar.must_equal 295.15
        end
      end

      describe "#magnitude" do
        it "must return the magnitude" do
          mph.magnitude.must_equal(60)
          cel.magnitude.must_equal(22)
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

      describe "#frozen?" do
        it "must be frozen" do
          subject.frozen?.must_equal true
        end
      end

    end
  end
end
