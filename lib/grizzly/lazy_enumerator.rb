module Grizzly
  class LazyEnumerator
    include ::Grizzly::Enumerable

    %i[
      select chunk chunk_while collect collect_concat compact drop drop_while
      eager enum_for filter filter_map find_all flat_map force grep grep_v
      map reject slice_after slice_before slice_when take take_while to_enum
      uniq with_index zip each_with_index with_index cycle each_with_object
      with_object each_slice each_entry each_cons each
    ].each do |method_name|
      define_method(method_name) do |*args, &block|
        subgroup @obj.send(method_name, *args, &block)
      end
    end

    attr_reader :obj, :instantiating_class
    def initialize(obj, instantiating_class: Array)
      @obj = obj
      @instantiating_class = instantiating_class
    end

    def subgroup(result)
      return new_lazy_enumerator(result) if result.is_a?(::Enumerator::Lazy)
      super
    end

    def lazy
      self
    end

    def size
      @obj.size
    end

    def to_a(*args, &block)
      @obj.to_a(*args, &block) # no subgroup?
    end
  end
end