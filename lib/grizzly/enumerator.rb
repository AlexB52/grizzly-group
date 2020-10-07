require 'forwardable'

module Grizzly
  class Enumerator < Enumerator
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