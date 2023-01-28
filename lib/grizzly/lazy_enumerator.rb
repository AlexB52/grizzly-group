module Grizzly
  class LazyEnumerator
    include ::Grizzly::Enumerable

    attr_reader :obj, :instantiating_class
    def initialize(obj, instantiating_class: Array)
      @obj = obj
      @instantiating_class = instantiating_class
    end

    def subgroup(result)
      return new_lazy_enumerator(result) if result.is_a?(::Enumerator::Lazy)
      super
    end

    def each(*args, &block)
      @obj.each(*args, &block)
    end

    def lazy
      self
    end

    def size
      @obj.size
    end

    # Lazy override

    def select(*args, &block)
      subgroup @obj.select(*args, &block)
    end

    def chunk(*args, &block)
      subgroup @obj.chunk(*args, &block)
    end

    def chunk_while(*args, &block)
      subgroup @obj.chunk_while(*args, &block)
    end

    def collect(*args, &block)
      subgroup @obj.collect(*args, &block)
    end

    def collect_concat(*args, &block)
      subgroup @obj.collect_concat(*args, &block)
    end

    def compact(*args, &block)
      subgroup @obj.compact(*args, &block)
    end

    def drop(*args, &block)
      subgroup @obj.drop(*args, &block)
    end

    def drop_while(*args, &block)
      subgroup @obj.drop_while(*args, &block)
    end

    def eager(*args, &block)
      subgroup @obj.eager(*args, &block)
    end

    def enum_for(*args, &block)
      subgroup @obj.enum_for(*args, &block)
    end

    def filter(*args, &block)
      subgroup @obj.filter(*args, &block)
    end

    def filter_map(*args, &block)
      subgroup @obj.filter_map(*args, &block)
    end

    def find_all(*args, &block)
      subgroup @obj.find_all(*args, &block)
    end

    def flat_map(*args, &block)
      subgroup @obj.flat_map(*args, &block)
    end

    def force(*args, &block)
      subgroup @obj.force(*args, &block)
    end

    def grep(*args, &block)
      subgroup @obj.grep(*args, &block)
    end

    def grep_v(*args, &block)
      subgroup @obj.grep_v(*args, &block)
    end

    def map(*args, &block)
      subgroup @obj.map(*args, &block)
    end

    def reject(*args, &block)
      subgroup @obj.reject(*args, &block)
    end

    def slice_after(*args, &block)
      subgroup @obj.slice_after(*args, &block)
    end

    def slice_before(*args, &block)
      subgroup @obj.slice_before(*args, &block)
    end

    def slice_when(*args, &block)
      subgroup @obj.slice_when(*args, &block)
    end

    def take(*args, &block)
      subgroup @obj.take(*args, &block)
    end

    def take_while(*args, &block)
      subgroup @obj.take_while(*args, &block)
    end

    def to_a(*args, &block)
      subgroup @obj.to_a(*args, &block)
    end

    def to_enum(*args, &block)
      subgroup @obj.to_enum(*args, &block)
    end

    def uniq(*args, &block)
      subgroup @obj.uniq(*args, &block)
    end

    def with_index(*args, &block)
      subgroup @obj.with_index(*args, &block)
    end

    def zip(*args, &block)
      subgroup @obj.zip(*args, &block)
    end
  end
end