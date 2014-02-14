require 'unitwise'
require 'ruby-units'
require 'benchmark'

Benchmark.bm(10) do |x|

  x.report('unitwise') do
    100000.times do |x|
      expression = "mm#{x % 20}"
      Unitwise::Measurement.new(x, expression)
    end
  end

  x.report('ruby-units') do
    100000.times do |x|
      expression = "mm^#{x % 20}"
      Unit(x, expression)
    end
  end

end
