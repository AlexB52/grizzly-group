module Grizzly
  module Enumerable
    include ::Enumerable

    def map(*args)
      subgroup(super)
    end

    def collect(*args)
      subgroup(super)
    end

    def grep(*args)
      raise NotImplementedError, "#{__method__} can't be supported. See https://bugs.ruby-lang.org/issues/11808"
    end

    def grep_v(*args)
      raise NotImplementedError, "#{__method__} can't be supported. See https://bugs.ruby-lang.org/issues/11808"
    end

    def zip(*other_arrays)
      result = super
      return result unless result.is_a?(Array)

      type = :self
      other_arrays.each do |array|
        case array
        when self.class
        when Grizzly::Collection
          type = :group
        else
          type = :array
          break
        end
      end

      case type
      when :self  then result.map { |a| new_collection(a) }
      when :group then result.map { |a| Grizzly::Collection.new(a) }
      else             result
      end
    end

    def partition(*args)
      result = super
      return new_enumerator(result) if result.is_a?(::Enumerator)
      return result unless result.is_a?(Array)

      [new_collection(result[0]), new_collection(result[1])]
    end

    def group_by(*args)
      result = super
      return new_enumerator(result) if result.is_a?(::Enumerator)
      return result unless result.is_a?(Hash)

      result.each do |key, value|
        result[key] = new_collection(value)
      end
    end

    def max(*args)
      subgroup(super)
    end

    def min(*args)
      subgroup(super)
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

    def filter_map(*args)
      subgroup(super)
    end

    def sort(*args)
      new_collection(super)
    end

    def reject(*args)
      subgroup(super)
    end

    def reject!(*args)
      subgroup(super)
    end

    def filter(*args)
      subgroup(super)
    end

    def filter!(*args)
      subgroup(super)
    end

    def select(*args)
      subgroup(super)
    end

    def select!(*args)
      subgroup(super)
    end

    def first(*args)
      result = super
      return result if args == []

      subgroup(result)
    end

    # Enumerator related

    def to_enum(*args)
      new_enumerator(super)
    end

    def take_while(*args)
      subgroup(super)
    end

    def slice_when(*args)
      new_enumerator(super)
    end

    def slice_before(*args)
      new_enumerator(super)
    end

    def slice_after(*args)
      new_enumerator(super)
    end

    def reverse_each(*args)
      subgroup(super)
    end

    def min_by(*args)
      subgroup(super)
    end

    def max_by(*args)
      subgroup(super)
    end

    def find_index(*args)
      subgroup(super)
    end

    def drop_while(*args)
      subgroup(super)
    end

    def chunk(*args)
      subgroup(super)
    end

    def chunk_while(*args)
      subgroup(super)
    end

    def each_slice(*args)
      subgroup(super)
    end

    def each_cons(*args)
      subgroup(super)
    end

    def each_entry(*args)
      subgroup(super)
    end

    def each_with_index(*args)
      subgroup(super)
    end

    def flat_map(*args)
      subgroup(super)
    end

    def collect_concat(*args)
      subgroup(super)
    end

    def find(*args)
      subgroup(super)
    end

    def detect(*args)
      subgroup(super)
    end

    # Lazy related methods

    def lazy
      new_lazy_enumerator(super)
    end


    def uniq(*args)
      subgroup(super)
    end

    private

    def subgroup(result)
      return result if is_self?(result)
      return new_enumerator(result) if result.is_a?(::Enumerator)
      return result unless result.is_a?(Array)

      new_collection(result)
    end

    def instantiating_class
      self.class
    end

    def new_collection(array)
      instantiating_class.new(array)
    end

    def new_enumerator(enum)
      Grizzly::Enumerator.new(enum, instantiating_class: instantiating_class)
    end

    def new_lazy_enumerator(lazy)
      Grizzly::LazyEnumerator.new(lazy, instantiating_class: instantiating_class)
    end

    def is_self?(obj)
      obj.object_id.eql? object_id
    end
  end
end