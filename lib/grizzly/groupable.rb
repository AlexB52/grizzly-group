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
      subgroup(super, method_name: __method__)
    end

    def minmax(*args)
      new_collection(super)
    end

    def sort_by(*args)
      subgroup(super, method_name: __method__)
    end

    def find_all(*args)
      subgroup(super, method_name: __method__)
    end

    def sort(*args)
      new_collection(super)
    end

    def reject(*args)
      subgroup(super, method_name: __method__)
    end

    def filter(*args)
      subgroup(super, method_name: __method__)
    end

    def select(*args)
      subgroup(super, method_name: __method__)
    end

    def first(*args)
      subgroup(super, method_name: __method__)
    end

    def last(*args)
      subgroup(super, method_name: __method__)
    end

    private

    def subgroup(result, method_name: nil)
      return new_enumerator(method_name) if result.is_a?(::Enumerator || Grizzly::Enumerator)
      return result unless result.is_a?(Array)
      return result if is_self?(result)

      new_collection(result)
    end

    def new_enumerator(method_name, *args)
      Grizzly::Enumerator.new(self, method_name, *args)
    end


    def new_collection(array)
      self.class.new(array)
    end

    def is_self?(obj)
      obj.object_id.eql? object_id
    end
  end
end