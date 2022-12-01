module Grizzly
  class Group < Array
    include Groupable

    def transpose(*args, **kargs)
      result = super
      if self.all? { |collection| collection.is_a?(self.class) }
        result = result.map { |collection| new_collection(collection) }
      end
      new_collection(result)
    end

    def product(*args, **kargs)
      result = super
      return result if is_self?(result)
      return result unless result.is_a?(Array)

      result.map {|product| new_collection(product)}
    end

    def values_at(*args, **kargs)
      new_collection(super)
    end

    def rotate(*args, **kargs)
      new_collection(super)
    end

    def compact(*args, **kargs)
      new_collection(super)
    end

    def shuffle(*args, **kargs)
      new_collection(super)
    end

    def reverse(*args, **kargs)
      new_collection(super)
    end

    def intersection(*args, **kargs)
      new_collection(super)
    end

    def &(*args, **kargs)
      new_collection(super)
    end

    def |(*args, **kargs)
      new_collection(super)
    end

    def +(*args, **kargs)
      new_collection(super)
    end

    def union(*args, **kargs)
      new_collection(super)
    end

    def -(*args, **kargs)
      new_collection(super)
    end

    def difference(*args, **kargs)
      new_collection(super)
    end

    def pop(*args, **kargs)
      subgroup(super)
    end

    def shift(*args, **kargs)
      subgroup(super)
    end
  end
end
