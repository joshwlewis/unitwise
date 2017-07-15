# Unitwise Changelog

All notable changes to Unitwise will be documented in this file, starting at
version 1.0.0.

Unitwise uses semantic versioning.

## Unreleased

## 2.2.0 - 2017-07-14

### Fixed

- Default units now stored as BigDecimal or Integer to reduce floating point
  accuracy loss.
- Added missing conversion for Degree Réaumur.

### Changed

- Performing mathematical operations or converting units will now use Rational
  math to prevent accuracy loss. In most cases, this means converted/operated
  on `Measurement`s will have a `Rational` `#value`. If you have an explicit
  dependency on the exact `Numeric` type that `Measurement#value` returns,
  consider using `#to_f` or `#to_i` instead.

### Removed

- Support for MRI 2.1

## 2.1.0 - 2017-04-28

### Removed

- Support for Ruby MRI 1.9.3, MRI 2.0, and Rubinius

### Added

- `Unitwise.register` is a new method that allows user defined units
- Support for MRI 2.3 and 2.4

### Changed

- Unit data refreshed from latest UCUM spec. Most notably, some metric atoms
  names have seen case changes.

## 2.0.0 - 2015-09-13

### Fixed

- Gem dependencies are less restrictive; now works with additional versions of
  parslet and blankslate.

### Removed

- 'unitwise/ext' is now officially removed. The core Numeric extensions are no
  longer available. Instead of `1.volt` or `2.0.to_joule`, use `Unitwise(1,
  'volt')` and `Unitwise(2.0, 'Joule')`.
- Dropped support for Ruby 1.8.7, 1.9.2, and REE.

## 1.1.0 - 2015-09-10

### Fixed

- `#to_s` should no longer return the unexpected ' 1' suffix for dimless measurements.
- `#to_s(mode)` will fall back to using the atom's `primary_code` if the mode
  isn't available.

### Deprecated

- `require unitwise/ext` has been deprecated as it is a performance drag and
  violates Ruby best practices. Use `require unitwise` instead. Any use of the
  Numeric helpers like `1.meter`, `2.to_foot` will need to change to
  `Unitwise(1, 'meter')`, and `Unitwise(2, 'foot')`.

## 1.0.4 - 2015-01-10

- Added Ruby 2.2 support.
- Empty strings are no longer valid units.

## 1.0.3 - 2014-10-05

### Added
- Unitwise.valid? for checking validity of expressions

## 1.0.2 - 2014-09-14

### Fixed
- Decomposer caching is now a little smarter. This resulted in a mild
  performance increase.

## 1.0.1 - 2014-08-30

### Fixed
- Move conditional dependencies to Gemfile in order to allow proper
  installation issues on rbx and jruby.

## 1.0.0 - 2014-08-25

### Added
- Uniwise() now accepts a Unitwise::Measurement as the first argument.
- Unitwise::Measurement now supports #round.

### Fixed
- Respect Rationals when inspecting/printing a Unitwise::Measurement.
- Dynamically created methods from unitwise/ext now work with #respond_to?
  and #methods appropriately.

### Deprecated
- Unitwise() and Unitwise::Measurement.new() now requires two non-optional
  arguments (value and unit).
- Unitwise::Measurement no longer has an implicit Integer conversion.
