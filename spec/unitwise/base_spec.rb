require 'spec_helper'

class Unitwise::Base
  def self.key
    "skeleton"
  end
end

describe Unitwise::Base do

  it "should have a data file" do
    Unitwise::Base.data_file.must_match /unitwise\/data\/skeleton.yaml$/
  end

end