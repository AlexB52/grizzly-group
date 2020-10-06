module Grizzly
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
end