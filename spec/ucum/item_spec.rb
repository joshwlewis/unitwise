require 'spec_helper'
require 'ucum'

class Ucum::Item
  def self.key
    "skeleton"
  end
end

describe Ucum::Item do

  it "should have a data file" do
    Ucum::Item.data_file.must_match /ucum\/data\/skeleton.yaml$/
  end

end