require_relative '../../spec_helper'

describe "Enumerable#sort_by" do
  it "returns a subclass of enumerable" do
    a = Numerous.new(["once", "upon", "a", "time"])
    a.sort_by { |i| i[0] }.should be_an_instance_of(Numerous)
  end

  # - core/enumerable/sort_by_spec.rb:6
  # - core/enumerable/sort_by_spec.rb:25
  # - core/enumerable/sort_by_spec.rb:30
  # - core/enumerable/sort_by_spec.rb:35
  it "returns an array of elements ordered by the result of block" do
    a = Numerous.new(["once", "upon", "a", "time"])
    a.sort_by { |i| i[0] }.should == Numerous.new(["a", "once", "time", "upon"])
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = YieldsMulti.new
    multi.sort_by {|e| e.size}.should == YieldsMulti.new([Grizzly::Collection.new([1, 2]), Grizzly::Collection.new([3, 4, 5]), Grizzly::Collection.new([6, 7, 8, 9])])
  end

  it "returns an array of elements when a block is supplied and #map returns an enumerable" do
    b = MapReturnsEnumerable.new
    b.sort_by{ |x| -x }.should == MapReturnsEnumerable.new([3, 2, 1])
  end

  it "calls #each to iterate over the elements to be sorted" do
    b = Numerous.new([1, 2, 3])
    b.should_receive(:each).once.and_yield(1).and_yield(2).and_yield(3)
    b.should_not_receive :map
    b.sort_by { |x| -x }.should == Numerous.new([3, 2, 1])
  end
end
