module Unitwise
  module CodeList
    def self.create(collection)
      collection.map(&:codes).flatten.sort do |x, y|
        y.length <=> x.length
      end
    end
  end
end