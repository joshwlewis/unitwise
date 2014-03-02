# [Unitwise](//github.com/joshwlewis/unitwise)

[![Gem Version](https://badge.fury.io/rb/unitwise.png)](http://badge.fury.io/rb/unitwise)
[![Build Status](https://travis-ci.org/joshwlewis/unitwise.png)](https://travis-ci.org/joshwlewis/unitwise)
[![Dependency Status](https://gemnasium.com/joshwlewis/unitwise.png)](https://gemnasium.com/joshwlewis/unitwise)
[![Coverage Status](https://coveralls.io/repos/joshwlewis/unitwise/badge.png)](https://coveralls.io/r/joshwlewis/unitwise)
[![Code Climate](https://codeclimate.com/github/joshwlewis/unitwise.png)](https://codeclimate.com/github/joshwlewis/unitwise)


Unitwise is a library for performing mathematical operations and conversions on all units defined by the [Unified Code for Units of Measure(UCUM)](http://unitsofmeasure.org/).

Unitwise supports a vast number of units. At the time of writing, it supports 95 metric units, 199 non-metric units, and 24 unit prefixes. That's approximately 2,500 basic units, but these can also be combined through multiplication and/or division to create an infinite number of possibilities.

## Usage

### Initialization:

Instantiate measurements with `Unitwise()`

```ruby
require 'unitwise'

Unitwise(2.3, 'kilogram') # => <Unitwise::Measurement 2.3 kilogram>
Unitwise('pound')         # => <Unitwise::Measurement 1 pound>
```

or require the core extensions for some syntactic sugar.

```ruby
require 'unitwise/ext'

1.convert('liter')
# => <Unitwise::Measurement 1 liter>

4.teaspoon
# => <Unitwise::Measurement 4 teaspoon>
```

### Conversion

Unitwise is able to convert any unit within the UCUM spec to any other
compatible unit.

```ruby
distance = Unitwise(5, 'kilometer') 
# => <Unitwise::Measurement 5 kilometer>

distance.convert('mile')
# => <Unitwise::Measurement 3.106849747474748 mile>
```

The prettier version of `convert(unit)` is just calling the unit as a method
name:

```ruby
distance = 26.2.mile
# => <Unitwise::Measurement 26.2 mile>

distance.kilometer
# => <Unitwise::Measurement 42.164897129794255 kilometer>
```

### Comparison

It also has the ability to compare measurements with the same or different units.

```ruby
12.inch == 1.foot # => true

1.meter > 1.yard # => true
```

Again, you have to compare compatible units. For example, comparing two 
temperatures will work, comparing a mass to a length would fail.

### SI abbreviations

You can use shorthand for SI units.

```ruby
1.m  # => <Unitwise::Measurement 1 meter>
1.ml #=> <Unitwise::Measurement 1 milliliter>
```

### Complex Units

Units can be combined to make more complex ones. There is nothing special about
them -- they can still be converted, compared, or operated on.

```ruby
speed = Unitwise(60, 'mile/hour')
# => <Unitwise::Measurement 60 mile/hour>

speed.convert('m/s')
# => <Unitwise::Measurement 26.822453644907288 m/s>
```

Exponents and parenthesis are supported as well.

```ruby
Unitwise(1000, 'kg.s-1.(m/s)2').watt
# => <Unitwise::Measurement 1000 watt>
```

### Math

You can add or subtract compatible measurements.

```ruby
2.meter + 3.inch - 1.yard
# => <Unitwise::Measurement 1.1618 meter>
```

You can multiply or divide measurements and numbers.

```ruby
110.volt * 2
# => <Unitwise::Measurement 220 volt>
```

You can multiply or divide measurements with measurements. Here is a fun example
from Physics 101

```ruby
m = 20.kg # => <Unitwise::Measurement 20 kg>

a = 10.m / 1.s2 # => <Unitwise::Measurement 10 m/s2>

f = m * a # => <Unitwise::Measurement 50 kg.m/s2>

f.newton # => <Unitwise::Measurement 50 newton>
```

### Unit Compatibility

Unitwise is fairly intelligent about unit compatibility. It boils each unit down
to it's basic composition to determine if they are compatible. For instance,
energy (say a Joule, which can be expressed as kg*m2/s2) would have the 
components mass<sup>1</sup>, length<sup>2</sup>, and 
time<sup>-2</sup>. Any unit that could be reduced to this same composition 
would be considered compatible. 

I've extracted this datatype into it's own gem ([SignedMultiset](//github.com/joshwlewis/signed_multiset)) if you find this construct interesting.

### Unit Names and Atom Codes

This library is based around the units in the UCUM specification, which is
extensive and well thought out. However, not all of our unit systems throughout
the world and history are consistent or logical. UCUM has devised a system where
each unit has a unique atom code to try and solve this. The previous code examples
don't show this, because for the most part you won't need it. Unitwise can
figure out most of the units by their name or symbol. If you find you need to
(or just want to be explicit) you use the UCUM atom codes without any
modification.

Just as an example, you can see here that there are actually a few versions of inch
and foot:

```ruby
1.convert('[ft_i]') == 1.convert('[ft_us]') # => false

3.convert('[in_br]') == 3.convert('[in_i]') # => false
```

### Available Units

If you are looking for a particular unit (or 'atom' in the UCUM spec), chances 
are that it is in here. There is a rudimentary search function for both
`Unitwise::Atom` and `Unitwise::Prefix`.

```ruby
Unitwise::Atom.search('fathom')
# => [ ... ]
Unitwise::Prefix.search('milli')
# => [ ... ]
```

You can also get the official list from the UCUM website in XML format at 
[unitsofmeasure.org/ucum-essence.xml](http://unitsofmeasure.org/ucum-essence.xml) 
or a YAML version within this repo 
[github.com/joshwlewis/unitwise/tree/master/data](//github.com/joshwlewis/unitwise/tree/master/data).

### Supported Ruby Versions

This library aims to support and is tested against the following Ruby
implementations:

* Ruby 1.9.3
* Ruby 2.0.0
* Ruby 2.1.0
* [JRuby](http://jruby.org/)
* [Rubinius](http://rubini.us/)

If something doesn't work on one of these versions, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby versions or
implementations, however support will only be provided for the implementations
listed above.

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
