require 'forwardable'

module Grizzly
  class Enumerator
    extend Forwardable

    Enumerable.public_instance_methods.each do |method_name|
      define_method(method_name) do |*args, &block|
        @obj.send(__method__, *args, &block)
      end
    end

    def_delegators :@enum, *%i{
      + first feed to_a
      next next_values
      peek peek_values
    }

    attr_reader :enum, :obj, :method_name, :args
    def initialize(obj, method_name = :each, *args, size: nil)
      @obj = obj
      @args = args
      @size = size
      @method_name = method_name
      @enum = obj.to_enum(method_name, *args)
    end

    def each(*args, &block)
      unless block_given?
        return args.any? ? new_enumerator(enum, __method__, *args) : self
      end

      enum.each(*args, &block)
    end

    def with_index(offset = 0, &block)
      unless block_given?
        return new_enumerator(self, __method__, offset)
      end

      enum.with_index(offset, &block)
    end

    def each_with_index(&block)
      with_index(&block)
    end

    def with_object(object, &block)
      unless block_given?
        return new_enumerator(self, __method__, object)
      end

      enum.with_object(object, &block)
    end
    alias :each_with_object :with_object

    def inspect
      enum.inspect.gsub('Enumerator', self.class.to_s)
    end

    def size
      @size || enum.size || obj&.size
    end

    def rewind
      enum.rewind && self
    end

    private

    def new_enumerator(obj, method_name, *args)
      self.class.new obj, method_name, *args, size: size
    end
  end
end
