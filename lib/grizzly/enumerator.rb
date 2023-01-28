require 'forwardable'

module Grizzly
  class Enumerator
    extend Forwardable
    include ::Grizzly::Enumerable

    def_delegators :@enum, *%i{
      + first feed to_a
      next next_values
      peek peek_values
      size
    }

    attr_reader :enum, :instantiating_class
    def initialize(enum, instantiating_class: Array)
      @enum = enum
      @instantiating_class = instantiating_class
    end

    def each(*args, &block)
      return self if args.empty? && !block_given?

      unless block_given?
        return new_enumerator(enum.each(*args))
      end

      enum.each(*args, &block)
    end

    def with_index(offset = 0, &block)
      unless block_given?
        return new_enumerator(@enum.with_index(offset))
      end

      enum.with_index(offset, &block)
    end

    def each_with_index(&block)
      with_index(&block)
    end

    def rewind
      enum.rewind && self
    end

    def with_object(object, &block)
      unless block_given?
        return new_enumerator(@enum.with_object(object))
      end

      enum.with_object(object, &block)
    end

    def each_with_object(object, &block)
      with_object(object, &block)
    end

    # def inspect
    #   enum.inspect.gsub('Enumerator', self.class.to_s)
    # end
  end
end