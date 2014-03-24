# [Unitwise](//github.com/joshwlewis/unitwise)

[![Gem Version](https://badge.fury.io/rb/unitwise.png)](http://badge.fury.io/rb/unitwise)
[![Build Status](https://travis-ci.org/joshwlewis/unitwise.png)](https://travis-ci.org/joshwlewis/unitwise)
[![Dependency Status](https://gemnasium.com/joshwlewis/unitwise.png)](https://gemnasium.com/joshwlewis/unitwise)
[![Coverage Status](https://coveralls.io/repos/joshwlewis/unitwise/badge.png)](https://coveralls.io/r/joshwlewis/unitwise)
[![Code Climate](https://codeclimate.com/github/joshwlewis/unitwise.png)](https://codeclimate.com/github/joshwlewis/unitwise)
[![Inline docs](http://inch-pages.github.io/github/joshwlewis/unitwise.png)](http://inch-pages.github.io/github/joshwlewis/unitwise)


Unitwise is a Ruby library for unit measurement conversion and math.

For an over the top example, consider a car (2800 lb) completing the quarter
mile in 10 seconds (with uniform acceleration).

```ruby
distance = 0.25.mile # => #<Unitwise::Measurement value=0.25 unit=mile>
time = 10.second # => #<Unitwise::Measurement value=10 unit=second>
mass = 2800.pound # => #<Unitwise::Measurement value=2800 unit=pound>

acceleration = 2 * distance / time ** 2
# => #<Unitwise::Measurement value=0.005 unit=[mi_us]/s2>

force = (mass * acceleration).to_lbf
# => #<Unitwise::Measurement value=2297.5084316991147 unit=lbf>

power = (force * distance / time).to_horsepower
# => #<Unitwise::Measurement value=551.4031264140402 unit=horsepower>

speed = ((2 * acceleration * distance) ** 0.5).convert_to("mile/hour")
# => #<Unitwise::Measurement value=180.0 unit=mile/hour>
```

## Rationale

Unitwise is based on the [Unified Code for Units of Measure(UCUM)](http://unitsofmeasure.org/),
which aims to maintain a cross-platform list of units and their conversions.
This gives Unitwise a few key advantages:

- An enormous list of units. At the time of writing, there are 96 metric units,
211 non-metric units, and 24 unit prefixes. Whatever unit/units you need, they
are here.

- An accurate and up to date set of units. The units, prefixes, and conversions
are maintained by UCUM, and are imported into this library with a rake task.

One of the objectives of Unitwise was that it should comprehend any combination
of units. For instance it needed to understand that a unit of
'kilogram.(meter/second)2' was equivalent to 'kilogram.meter.(meter/second2)'.
This resulted in two unique features:

- An expression grammar built with a PEG parser. This makes expression
parsing more efficient and allows nested parentheses. For example, this is possible: '(kilogram.(meter/second)2)2'

- Smart compatibility detection. Each unit is reduced down to its most elementary
atoms to determine compatibility with another unit. For example, it knows that
'meter/second2' should be considered compatible with 'kilogram.foot.minute-2/pound'.

## Usage

### Initialization:

Measurements can be instantiated with `Unitwise()`.

```ruby
require 'unitwise'

Unitwise(2.3, 'kilogram') # => #<Unitwise::Measurement value=2.3 unit=kilogram>
Unitwise('pound')         # => #<Unitwise::Measurement value=1 unit=pound>
```

Unitwise doesn't mess with the Ruby core library by default. So if you want
the syntactic sugar shown throughout this document, you'll need to require the
core extensions.

```ruby
require 'unitwise/ext'

1.convert_to('liter') # => #<Unitwise::Measurement value=1 unit=liter>
4.teaspoon            # => #<Unitwise::Measurement value=4 unit=teaspoon>
```

### Conversion

Unitwise is able to convert any unit within the UCUM spec to any other
compatible unit.

```ruby
5.kilometer.convert_to('mile')
# => #<Unitwise::Measurement value=3.106849747474748 unit=mile>
```

The prettier version of `convert_to(unit)` is appending the unit code, name, etc.
to a `to_` message.
name.

```ruby
Unitwise(26.2, 'mile').to_kilometer
# => #<Unitwise::Measurement value=42.164897129794255 unit=kilometer>
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
1000.m == 1.km # => true
1.ml == 0.001.l # => true
```

### Complex Units

Units can be combined to make more complex ones. There is nothing special about
them -- they can still be converted, compared, or operated on.

```ruby
speed = Unitwise(60, 'mile/hour')
# => #<Unitwise::Measurement value=60 unit=mile/hour>

speed.convert_to('m/s')
# => #<Unitwise::Measurement value=26.822453644907288 unit=m/s>
```

Exponents and parenthesis are supported as well.

```ruby
Unitwise(1000, 'kg.s-1.(m/s)2').to_kilowatt
# => #<Unitwise::Measurement value=1.0 unit=kilowatt>
```

### Math

You can add or subtract compatible measurements.

```ruby
2.meter + 3.inch - 1.yard
# => #<Unitwise::Measurement value=1.1618 unit=meter>
```

You can multiply or divide measurements and numbers.

```ruby
110.volt * 2
# => #<Unitwise::Measurement value=220 unit=volt>
```

You can multiply or divide measurements with measurements.

```ruby
20.milligram / 1.liter
# => #<Unitwise::Measurement value=20 unit=mg/l>

```

Exponentiation is also supported.

```ruby
(10.cm ** 3).to_liter
# => #<Unitwise::Measurement value=1.0 unit=liter>
```

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
1.convert_to('[ft_i]') == 1.convert_to('[ft_us]') # => false

3.convert_to('[in_br]') == 3.convert_to('[in_i]') # => false
```

### Available Units

If you are looking for a particular unit, you can search with a string or
Regexp.

```ruby
Unitwise.search('fathom')
# => [ ... ]

```

You can also get the official list from the UCUM website in XML format at
[unitsofmeasure.org/ucum-essence.xml](http://unitsofmeasure.org/ucum-essence.xml)
or a YAML version within this repo
[github.com/joshwlewis/unitwise/tree/master/data](//github.com/joshwlewis/unitwise/tree/master/data).

## Supported Ruby Versions

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
