module Unitwise
  # The search module provides a simple search mechanism around known basic
  # units. The full list of avaliable units infinite, so this search creates
  # a small subset of atoms and prefixes to help users find what they are
  # looking for. Thus, there is a multitude of valid units that may be
  # constructed that this module will not be aware of.
  module Search
    class << self
      # An abbreviated list of possible units. These are known combinations
      # of atoms and prefixes.
      # @return [Array] A list of known units
      # @api public
      def all
        @all ||= begin
          units = []
          Atom.all.each do |a|
            units << build(a)
            Unitwise::Prefix.all.each { |p| units << build(a, p) } if a.metric?
          end
          units
        end
      end

      # Search the list of known units for a match.
      # @param term [String, Regexp] The term to search for
      # @return [Array] A list of matching units.
      # @api public
      def search(term)
        all.select do |unit|
          unit.aliases.any? { |str| Regexp.new(term).match(str) }
        end
      end

      private

      # Helper method for building a new unit by a known atom and prefix.
      # @param atom [Unitwise::Atom]
      # @param prefix [Unitwise::Prefix, nil]
      # @return [Unitwise::Unit]
      # @api private
      def build(atom, prefix = nil)
        Unit.new([Term.new(:atom => atom, :prefix => prefix)])
      end
    end
  end
end
