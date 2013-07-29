module Unitwise
  class Function
    include Math
    class << self
      def all
        @all ||= defaults
      end

      def defaults
        [ ["cel",   ->(x){ x - 273.15},           ->(x){ x + 273.15}          ],
          ["degf",  ->(x){9.0 * x / 5.0 - 459.67},->(x){ 5.0/9 * (x + 459.67)}],
          ["hpX",   ->(x){ -log10(x) },           ->(x){ 10 ** -x }           ],
          ["hpC",   ->(x){ -log(x) / log(100) },  ->(x){ 100 ** -x }          ],
          ["tan100",->(x){ 100 * tan(x) },        ->(x){ atan(x / 100) }      ],
          ["ph",    ->(x){ -log10(x) },           ->(x){ 10 ** -x }           ],
          ["ld",    ->(x){ log2(x) },             ->(x){ 2 ** -x }            ],
          ["ln",    ->(x){ log(x) },              ->(x){ Math::E ** x }       ],
          ["lg",    ->(x){ log10(x) },            ->(x){ 10 ** x }            ],
          ["2lg",   ->(x){ 2 * log10(x) },         ->(x){ (10 ** x) / 2 }     ]
        ].map {|args| new(*args) }
      end

      def add(*args)
        new_instance = self.new(*args)
        all << new_instance
        new_instance
      end

      def find(name)
        all.find{|fp| fp.name == name}
      end
    end

    attr_reader :name, :direct, :inverse

    def initialize(name, direct, inverse)
      @name = name
      @direct = direct
      @inverse = inverse
    end

    def functional(x, direction=1)
      if direction == 1
        direct.call(x)
      elsif direction == -1
        inverse.call(x)
      end
    end

  end
end