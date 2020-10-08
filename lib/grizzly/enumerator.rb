require 'forwardable'

module Grizzly
  class Enumerator
    extend Forwardable

    def_delegators :@enum, *%i{
      + first feed to_a
      next next_values
      peek peek_values
    }

    attr_reader :enum, :obj, :method_name, :args
    def initialize(obj, method_name = :each, size = nil, *args)
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
      @size || enum.size
    end

    def rewind
      enum.rewind && self
    end

    private

    def new_enumerator(obj, method_name, *args)
      self.class.new obj, method_name, size, *args
    end
  end

  # class Enumerator < Enumerator
  #   extend Forwardable

  #   OVERRIDE_METHODS = %i{with_index with_object each_with_index each_with_object}
  #   ENUMERATOR_METHODS = Enumerator.public_instance_methods(false)
  #   ENUMERABLE_METHODS = Enumerable.public_instance_methods

  #   alias :old_enum :to_enum

  #   def_delegators :@enum, *ENUMERATOR_METHODS

  #   ENUMERABLE_METHODS.each do |method_name|
  #     define_method(method_name) do |*args, &block|
  #       return to_enum(__method__, *args) unless block

  #       @object.send(__method__, *args, &block)
  #     end
  #   end

  #   OVERRIDE_METHODS.each do |method_name|
  #     define_method(method_name) do |*args, &block|
  #       return to_enum(__method__, *args) unless block

  #       @enum.send(:each, *args, &block)
  #     end
  #   end

  #   attr_reader :object, :enum

  #   def initialize(object, method_name, *args)
  #     @object = object
  #     @enum = object.to_enum(method_name, *args)
  #   end

  #   def to_enum(method_name, *args)
  #     self.class.new @object, method_name, *args
  #   end
  # end
end