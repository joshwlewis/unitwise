require 'test_helper'

describe Unitwise::Functional do
  subject { Unitwise::Functional }
  %w{cel degf hpX hpC tan100 ph ld ln lg 2lg}.each do |function|
    function = :"_#{function}"
    describe function do
      it 'should convert back and forth' do
        number = rand.round(5)
        there = subject.send function, number, true
        back_again = subject.send function, there, false
        back_again.round(5).must_equal number
      end
    end
  end
end
