require 'spec_helper'
require 'unitwise'

class Unitwise::Item
  def self.key
    "skeleton"
  end
end

describe Unitwise::Item do

  it "should have a data file" do
    Unitwise::Item.data_file.must_match /unitwise\/data\/skeleton.yaml$/
  end

end