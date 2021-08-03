module Grizzly
  class Group < Array
    include Groupable

    alias old_permutation permutation
    def permutation(n = size, &block)
      if block_given?
        old_permutation(n) { |perm| block.call new_collection(perm) }
        self
      else
        result = old_permutation(n)
        if result.size == 0
          Grizzly::Enumerator.new([], __method__, n)
        else
          Grizzly::Enumerator.new(self, __method__, n, size: result.size)
        end
      end
    end

    def each
      result = super
      return new_enumerator(__method__) if result.is_a?(::Enumerator)
      result
    end

    def delete_if
      result = super
      return new_enumerator(__method__) if result.is_a?(::Enumerator)
      result
    end

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
      subgroup(super, method_name: __method__)
    end

    def shift(*args)
      subgroup(super, method_name: __method__)
    end
  end
end
