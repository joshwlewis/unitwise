require 'test_helper'

describe String do
  describe '#to_slug' do
    it "should convert 'Pascal' to 'pascal'" do
      "Pascal".to_slug.must_equal 'pascal'
    end

    it "should convert 'degree Celsius' to 'degree_celsius'" do
      "degree Celsius".to_slug.must_equal 'degree_celsius'
    end
  end
end