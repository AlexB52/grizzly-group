module Grizzly
  class Collection < Array
    include Grizzly::Enumerable

    def collect(*args)
      subgroup(super)
    end

    def map(*args)
      subgroup(super)
    end

    def transpose(*args)
      result = super
      if self.all? { |collection| collection.is_a?(self.class) }
        result = result.map { |collection| new_collection(collection) }
      end
      new_collection(result)
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

    def shuffle(*args, **kargs)
      new_collection(super)
    end

    def reverse(*args)
      new_collection(super)
    end

    def intersection(*args)
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

    def *(*args)
      subgroup(super)
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

    def flatten(*args)
      new_collection(super)
    end

    def sample(*args, **karg)
      subgroup(super)
    end

    def drop(*args)
      new_collection(super)
    end

    def drop_while(*args)
      subgroup(super)
    end

    def last(*args)
      result = super
      return result if args == []

      subgroup(result)
    end

    def slice(*args)
      result = super
      return result if args.count == 1 && args.first.is_a?(Integer)

      subgroup(result)
    end

    def slice!(*args)
      result = super
      return result if args.count == 1 && args.first.is_a?(Integer)

      subgroup(result)
    end

    def [](*args)
      result = super
      return result if args.count == 1 && args.first.is_a?(Integer)

      subgroup(result)
    end

    def take(*args)
      new_collection(super)
    end

    def take_while(*args)
      subgroup(super)
    end

    def uniq(*args)
      new_collection(super)
    end
  end
end
