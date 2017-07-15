require 'test_helper'

describe Unitwise::Functional do
  subject { Unitwise::Functional }
  %w{cel degf degre hpX hpC tan100 ph ld ln lg 2lg}.each do |function|
    describe function do
      it 'should convert back and forth' do
        number = rand(1000) / 1000.0
        there = subject.send "to_#{function}", number
        back_again = subject.send "from_#{function}", there
        rounded_result = (back_again * 1000).round / 1000.0
        rounded_result.must_equal number
      end
    end
  end

end
