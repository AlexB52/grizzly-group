module Grizzly
  module Enumerable
    include ::Enumerable

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
      result = super
      return result if args == []

      subgroup(result)
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
end