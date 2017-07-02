require 'test_helper'

describe Unitwise::Number do
  describe "simplify" do
    it "simplifies to an Integer" do
      [2, 2.0, BigDecimal.new(2), '2', '2.0'].each do |n|
        assert_equal Unitwise::Number.simplify(n), 2
      end
    end

    it "simplifies to a Float" do
      [2.25, BigDecimal.new('2.25'), '2.25'].each do |n|
        assert_equal Unitwise::Number.simplify(n), 2.25
      end
    end
  end
end
