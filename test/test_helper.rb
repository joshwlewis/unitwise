require 'covered/minitest'
require 'minitest/autorun'
require 'minitest/pride'

require 'unitwise'

module Minitest::Assertions
  def assert_almost_equal(expected, actual, range=0.0001)
    message = "Expected #{actual} to be almost equal to #{expected}"
    assert expected + range > actual && expected - range < actual, message
  end
end

Numeric.infect_an_assertion :assert_almost_equal, :must_almost_equal
