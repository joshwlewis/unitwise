module Unitwise
  # A compound is a combination of an atom and a prefix.
  # This class is isolated from the rest of the code base and primarily exists
  # for the convenience of listing and searching possible combinations
  # of atoms and prefixes.
  class Compound < Liner.new(:atom, :prefix)
    # List all possible compounds
    # @return [Array]
    # @api public
    def self.all
      @all || build
    end

    # Builds up the list of possible compounds. Only required if you are
    # defining your own atoms/prefixes.
    # @return [Array]
    # @api public
    def self.build
      compounds = Atom.all.map { |a| new(a) }
      Atom.all.select(&:metric).each do |a|
        Prefix.all.each do |p|
          compounds << new(a, p)
        end
      end
      @all = compounds
    end

    # Search for compounds with a search term
    # @param [String, Regexp] What to search for
    # @return [Array]
    # @api public
    def self.search(term)
      all.select do |compound|
        compound.search_strings.any? { |str| Regexp.new(term).match(str) }
      end
    end

    [:primary_code, :secondary_code, :symbol].each do |attr|
      define_method attr do
        instance_variable_get("@#{attr}") ||
        instance_variable_set("@#{attr}",
          prefix ? "#{prefix.send attr}#{atom.send attr}" : atom.send(attr))
      end
    end

    [:names, :slugs].each do |attr|
      define_method attr do
        instance_variable_get("@#{attr}") ||
        instance_variable_set("@#{attr}",
          if prefix
            prefix.send(attr).zip(atom.send(attr)).map { |set| set.join('') }
          else
            atom.send(attr)
          end)
      end
    end

    def atom=(value)
      value.is_a?(Atom) ? super(value) : super(Atom.find value)
    end

    def prefix=(value)
      value.is_a?(Prefix) ? super(value) : super(Prefix.find value)
    end

    def search_strings
      @search_strings ||= [primary_code, secondary_code, symbol,
                           names, slugs].flatten.uniq
    end

    def attribute_string
      [:atom, :prefix, :primary_code, :secondary_code,
       :symbol, :names, :slugs].map do |attr|
        "#{attr}='#{send attr}'"
      end.join(', ')
    end

    def to_s(mode = :primary_code)
      res = send(mode)
      res.respond_to?(:each) ? res.first : res
    end
  end
end
