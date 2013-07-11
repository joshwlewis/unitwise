# Unitwise

Unitwise is a library for performing mathematical operations and conversions on all units defined by the [Unified Code for Units of Measure(UCUM)](http://unitsofmeasure.org/).

Unitwise supports a vast number of units. At the time of writing, it supports 95 metric units, 199 non-metric units, and 24 unit prefixes. That's approximately 2,500 basic units, but these can also be combined through multiplication and/or division to create an infinite number of possibilities.

Please note that while Unitwise is functional, it is still under development.

## Usage

### Initialization:

```ruby

require 'unitwise'

2.3.kilogram # => <Unitwise::Measurement 2.3 kilogram>

4.convert('pound') # => <Unitwise::Measurement 4 pound>

```

### Conversion

```ruby

26.2.mile.kilometer # => <Unitwise::Measurement 42.164897129794255 kilometer>

5.kilometer.convert('mile') # => <Unitwise::Measurement 3.106849747474748 mile>

```

### Comparison

```ruby

12.inch == 1.foot # => true

1.meter > 1.yard # => true

```

### Math

Note that you can also use SI abbreviations for units instead of names (i.e. ms for millisecond).

```ruby

m = 20.kg # => <Unitwise::Measurement 20 kg>

a = 10.m / 1.s2 # => <Unitwise::Measurement 10 m/s2>

f = m * a # => <Unitwise::Measurement 50 kg.m/s2>

f.newton # => <Unitwise::Measurement 50 newton>

```

## UCUM Atom Codes

There are several units that share names in the UCUM specification. There are a few versions of inch and foot, for example. So, specifying `1.foot` may not always be appropriate. You may have to use a UCUM Atom code instead of the unit name:

```ruby

1.convert('[ft_i]') == 1.convert('[ft_us]') # => false

3.convert('[in_br]') == 3.convert('[in_i]') # => false

```

## Compound Units

You can create compound units by multiplying or dividing measurements, or by using a compound string.

```ruby

20.mile / 1.hour == 20.convert("mile/hour") # => true

4.convert("kg.(m/s)2") == 4.joule # => true

```

## Installation

Add this line to your application's Gemfile:

    gem 'unitwise'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unitwise


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
