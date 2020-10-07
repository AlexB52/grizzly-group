require 'forwardable'

module Grizzly
  class Enumerator
    extend Forwardable

    def_delegators :@enum, *%i{
      + first feed to_a
      next next_values
      peek peek_values
    }

    attr_reader :enum
    def initialize(enum, size = nil)
      @enum = enum
      @size = size
    end

    def each(*args, &block)
      unless block_given?
        return args.any? ? new_enumerator(enum, __method__, *args) : self
      end

      enum.each(*args, &block)
    end

    def with_index(*args, &block)
      unless block_given?
        return new_enumerator(self, __method__, *args)
      end

      enum.with_index(*args, &block)
    end

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
      self.class.new obj.to_enum(method_name, *args), size
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