module Unitwise
  module CodeList
    def self.create(collection)
      collection.inject([]) do |a,i|
        i.codes.each { |c| a << Regexp.escape(c) if c }; a
      end.sort do |x, y|
        y.length <=> x.length
      end.join('|')
    end
  end
end