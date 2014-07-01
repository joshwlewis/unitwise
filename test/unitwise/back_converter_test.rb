require 'test_helper'

class Converter
  include Unitwise::BackConverter
end

describe Unitwise::BackConverter do
  let(:converter) { Converter.new }
  describe "when the value is equivalent to an Integer" do
    it "should convert from a Rational" do
      result = converter.back_convert(Rational(20,2))
      result.must_equal 10
      result.must_be_kind_of(Integer)
    end
    it "should convert from a Float" do
      result = converter.back_convert(4.0)
      result.must_equal 4
      result.must_be_kind_of(Integer)
    end
  end
  describe "when the value is equivalent to a Float" do
    it "should convert from a BigDecimal" do
      result = converter.back_convert(BigDecimal("1.5"))
      result.must_equal 1.5
      result.must_be_kind_of(Float)
    end
  end
end
