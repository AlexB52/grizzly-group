require 'forwardable'

module Groupable
  def zip(*args)
    result = super
    return result unless result.is_a?(Array)

    result.map {|zipped| new_collection(zipped)}
  end

  def partition(*args)
    result = super
    return result unless result.is_a?(Array)

    [new_collection(result[0]), new_collection(result[1])]
  end

  def group_by(*args)
    result = super
    return result unless result.is_a?(Hash)

    result.each do |key, value|
      result[key] = new_collection(value)
    end
  end

  def minmax_by(*args)
    subgroup(super)
  end

  def minmax(*args)
    new_collection(super)
  end

  def sort_by(*args)
    subgroup(super)
  end

  def find_all(*args)
    subgroup(super)
  end

  def sort(*args)
    new_collection(super)
  end

  def reject(*args)
    subgroup(super)
  end

  def filter(*args)
    subgroup(super)
  end

  def select(*args)
    subgroup(super)
  end

  def first(*args)
    subgroup(super)
  end

  def last(*args)
    subgroup(super)
  end

  private

  def subgroup(result)
    return result unless result.is_a?(Array)
    return result if is_self?(result)

    new_collection(result)
  end

  def new_collection(array)
    self.class.new(array)
  end

  def is_self?(obj)
    obj.object_id.eql? object_id
  end
end

class Grizzly::Group < Array
  include Groupable

  def transpose(*args)
    new_collection(super)
  end

  def product(*args)
    result = super
    return result if is_self?(result)
    return result unless result.is_a?(Array)

    result.map {|product| new_collection(product)}
  end

  def values_at(*args)
    new_collection(super)
  end

  def rotate(*args)
    new_collection(super)
  end

  def compact(*args)
    new_collection(super)
  end

  def shuffle(*args)
    new_collection(super)
  end

  def reverse(*args)
    new_collection(super)
  end

  def &(*args)
    new_collection(super)
  end

  def |(*args)
    new_collection(super)
  end

  def +(*args)
    new_collection(super)
  end

  def union(*args)
    new_collection(super)
  end

  def -(*args)
    new_collection(super)
  end

  def difference(*args)
    new_collection(super)
  end

  def pop(*args)
    subgroup(super)
  end

  def shift(*args)
    subgroup(super)
  end
end


class Grizzly::Enumerator < Enumerator
  extend Forwardable

  METHODS = %i{+ each feed inspect next next_values peek peek_values rewind size with_index with_object}
  # each_with_index each_with_object
  ENUMERABLE_METHODS = %i{all? any? chain chunk chunk_while collect collect_concat count cycle detect drop drop_while each_cons each_entry each_slice each_with_index each_with_object entries filter filter_map find find_all find_index first flat_map grep grep_v group_by include? inject lazy map max max_by member? min min_by minmax minmax_by none? one? partition reduce reject reverse_each select slice_after slice_before slice_when sort sort_by sum take take_while tally to_a to_h uniq zip}
  #filter_map tally
  alias :old_enum :to_enum

  def_delegators :@enum, *METHODS

  ENUMERABLE_METHODS.each do |method_name|
    define_method(method_name) do |*args, &block|
      return to_enum(__method__, *args) unless block

      @object.send(__method__, *args, &block)
    end
  end

  attr_reader :object
  def initialize(object, method_name, *args)
    @object = object
    @enum = object.to_enum(method_name, *args)
  end

  def to_enum(method_name, *args)
    self.class.new @object, method_name, *args
  end
end

# class Grizzly::Enumerator < Enumerator
#   extend Forwardable

#   METHODS = %i{+ each each_with_index each_with_object feed inspect next next_values peek peek_values rewind size with_index with_object}

#   #filter_map tally
#   alias :old_enum :to_enum

#   def_delegators :@enum, *METHODS

#   def select(*args)
#     return to_enum(__method__, *args) unless block_given?
#     super
#   end

#   def initialize(object, method_name, *args)
#     @object = object
#     @enum = object.to_enum(method_name, *args)
#   end

#   def to_enum(method_name, *args)
#     self.class.new @object, method_name, *args
#   end
# end

