require 'test_helper'
require 'support/scale_tests'

describe Unitwise::Scale do
  let(:described_class) { Unitwise::Scale }
  include ScaleTests

  # Regression tests for issue [35]
  it "must convert to feet and back to meter without loss of precision" do
    m = Unitwise(10, 'm')
    feet = m.to_foot
    feet.to_meter.to_f.must_equal(10)
  end

  it "must convert circle to degree without loss of precision" do
    circle = Unitwise(1, 'circle')
    circle.convert_to('degree').to_f.must_equal(360)
  end
end
