module Grizzly
  module Enumerable
    include ::Enumerable

    %i[
      max min minmax_by sort_by find_all filter_map reject reject! filter filter!
      select select! take_while reverse_each min_by max_by find_index drop_while
      chunk chunk_while each_slice each_cons each_entry each_with_index flat_map
      collect_concat find detect uniq collect map
    ].each do |method_name|
      define_method(method_name) do |*args, &block|
        subgroup super(*args, &block)
      end
    end

    %i[minmax sort].each do |method_name|
      define_method(method_name) do |*args, &block|
        subgroup super(*args, &block)
      end
    end

    %i[to_enum slice_when slice_before slice_after].each do |method_name|
      define_method(method_name) do |*args, &block|
        new_enumerator super(*args, &block)
      end
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

    def first(*args)
      result = super
      return result if args == []

      subgroup(result)
    end

    # Lazy related methods

    def lazy
      new_lazy_enumerator(super)
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