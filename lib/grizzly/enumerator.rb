require 'forwardable'

module Grizzly
  class Enumerator < Enumerator
    include ::Grizzly::Enumerable

    # def_delegators :@enum, *%i{
    #   + first feed to_a
    #   next next_values
    #   peek peek_values
    # }

    attr_reader :enum, :instantiating_class
    def initialize(enum, instantiating_class: Array)
      @enum = enum
      @instantiating_class = instantiating_class
    end

    def size
      @enum.size
    end

    def each(*args, &block)
      # unless block_given?
      #   return args.any? ? new_enumerator(enum, __method__, *args) : self
      # end

      enum.each(*args, &block)
    end

    # def with_index(offset = 0, &block)
    #   unless block_given?
    #     return new_enumerator(self, __method__, offset)
    #   end

    #   enum.with_index(offset, &block)
    # end

    # def each_with_index(&block)
    #   with_index(&block)
    # end

    # def with_object(object, &block)
    #   unless block_given?
    #     return new_enumerator(self, __method__, object)
    #   end

    #   enum.with_object(object, &block)
    # end
    # alias :each_with_object :with_object

    # def inspect
    #   enum.inspect.gsub('Enumerator', self.class.to_s)
    # end

    # def rewind
    #   enum.rewind && self
    # end
  end
end