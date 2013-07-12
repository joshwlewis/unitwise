module Unitwise
  class FunctionPair
    class << self
      def all
        @all ||= []
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

    attr_reader :name, :forward, :reverse

    def initialize(name, forward, reverse)
      @name = name
      @forward = forward
      @reverse = reverse
    end

  end
end