if RUBY_VERSION > '1.8.7'
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
require 'minitest/pride'

require 'unitwise'

module Minitest::Assertions
  def assert_almost_equal(expected, actual)
    message = "Expected #{expected} to be almost equal to #{actual}"
    range   = 0.00001
    assert expected + range > actual && expected - range < actual, message
  end
end

Numeric.infect_an_assertion :assert_almost_equal, :must_almost_equal
