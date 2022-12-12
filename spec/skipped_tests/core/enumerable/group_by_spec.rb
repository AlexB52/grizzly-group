require_relative '../../spec_helper'

class YieldsMulti < Grizzly::Collection
  def each
    yield 1,2
    yield 3,4,5
    yield 6,7,8,9
  end
end

class Numerous
  include Grizzly::Enumerable
  include Comparable

  attr_reader :list
  def initialize(*list)
    list = list.empty? ? [2, 5, 3, 6, 1, 4] : list
    @list = Grizzly::Collection.new(list)
  end

  def <=>(other)
    list <=> other.list
  end

  def each
    @list.each { |i| yield i }
  end
end

describe "Enumerable#group_by" do
  # core/enumerable/group_by_spec.rb:6
  it "returns a hash with values grouped according to the block" do
    e = Numerous.new("foo", "bar", "baz")
    h = e.group_by { |word| word[0..0].to_sym }
    h.should == { f: Numerous.new(["foo"]), b: Numerous.new(["bar", "baz"])}
  end

  # core/enumerable/group_by_spec.rb:28
  it "gathers whole arrays as elements when each yields multiple" do
    e = YieldsMulti.new
    h = e.group_by { |i| i }
    h.should == { YieldsMulti.new([1, 2]) => [YieldsMulti.new([1, 2])],
                  YieldsMulti.new([6, 7, 8, 9]) => [YieldsMulti.new([6, 7, 8, 9])],
                  YieldsMulti.new([3, 4, 5]) => [YieldsMulti.new([3, 4, 5])] }
  end
end
