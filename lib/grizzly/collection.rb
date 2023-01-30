
module Grizzly
  class Collection < Array
    include Grizzly::Enumerable

    %i[
      each collect! map! sort_by! * pop shift drop_while take_while bsearch_index
      bsearch combination delete_if each_index keep_if find_index index permutation
      repeated_combination repeated_permutation reverse_each rindex max min
    ].each do |method_name|
      define_method(method_name) do |*args, &block|
        subgroup super(*args, &block)
      end
    end

    %i[
      values_at rotate compact reverse intersection & | + union - difference
      flatten drop take
    ].each do |method_name|
      define_method(method_name) do |*args|
        new_collection super(*args)
      end
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

    def sample(*args, **karg)
      subgroup(super)
    end

    def shuffle(*args, **kargs)
      new_collection(super)
    end
  end
end
