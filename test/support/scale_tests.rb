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
          _(subject.value).must_equal(4)
          _(subject.unit.to_s).must_equal('J')
        end
      end

      describe "#unit" do
        it "must be a unit" do
          _(subject).must_respond_to(:unit)
          _(subject.unit).must_be_instance_of(Unitwise::Unit)
        end
      end

      describe "#root_terms" do
        it "must be a collection of terms" do
          _(subject).must_respond_to(:root_terms)
          _(subject.root_terms).must_be_kind_of Enumerable
          _(subject.root_terms.first).must_be_instance_of(Unitwise::Term)
        end
      end

      describe "#terms" do
        it "must return an array of terms" do
          _(subject.terms).must_be_kind_of(Enumerable)
          _(subject.terms.first).must_be_kind_of(Unitwise::Term)
        end
      end

      describe "#atoms" do
        it "must return an array of atoms" do
          _(subject.atoms).must_be_kind_of(Enumerable)
          _(subject.atoms.first).must_be_kind_of(Unitwise::Atom)
        end
      end

      describe "#scalar" do
        it "must return value relative to terminal atoms" do
          _(subject.scalar).must_equal 4000
          _(mph.scalar).must_almost_equal 26.8224
          _(cel.scalar).must_equal 295.15
        end
      end

      describe "#magnitude" do
        it "must return the magnitude" do
          _(mph.magnitude).must_equal(60)
          _(cel.magnitude).must_equal(22)
        end
      end

      describe "#special?" do
        it "must return true when unit is special, false otherwise" do
          _(subject.special?).must_equal false
          _(cel.special?).must_equal true
        end
      end

      describe "#depth" do
        it "must return a number indicating how far down the rabbit hole goes" do
          _(subject.depth).must_equal 11
          _(k.depth).must_equal 3
        end
      end

      describe "#frozen?" do
        it "must be frozen" do
          _(subject.frozen?).must_equal true
        end
      end

      describe "#simplified_value" do
        it "must simplify to an Integer" do
          result = described_class.new(4.0, 'foot').simplified_value
          _(result).must_equal 4
          _(result).must_be_kind_of(Integer)
        end

        it "must simplify to a Float" do
          result = described_class.new(BigDecimal("1.5"), 'foot').simplified_value
          _(result).must_equal 1.5
          _(result).must_be_kind_of(Float)
        end
      end

      describe "#inspect" do
        it "must show the unit and value" do
          result = described_class.new(12, 'meter').inspect
          _(result).must_include("value=12")
          _(result).must_include("unit=meter")
        end
      end
    end
  end
end
