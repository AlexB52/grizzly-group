require_relative '../../spec_helper'

# - core/enumerable/sort_spec.rb:5
# - core/enumerable/sort_spec.rb:11
# - core/enumerable/sort_spec.rb:22
# - core/enumerable/sort_spec.rb:31
# - core/enumerable/sort_spec.rb:46
# - core/enumerable/sort_spec.rb:51

describe "Enumerable#sort" do
  it "sorts by the natural order as defined by <=>" do
    Numerous.new.sort.should == Numerous.new([1, 2, 3, 4, 5, 6])
    sorted = ComparesByVowelCount.wrap("a" * 1, "a" * 2, "a"*3, "a"*4, "a"*5)
    Numerous.new([sorted[2],sorted[0],sorted[1],sorted[3],sorted[4]]).sort.should == Numerous.new(sorted)
  end

  it "raises a NoMethodError if elements do not define <=>" do
    -> do
      Numerous.new([BasicObject.new, BasicObject.new, BasicObject.new]).sort
    end.should raise_error(NoMethodError)
  end

  it "sorts enumerables that contain nils" do
    arr = Numerous.new([nil, true, nil, false, nil, true, nil, false, nil])
    arr.sort { |a, b|
      x = a ? -1 : a.nil? ? 0 : 1
      y = b ? -1 : b.nil? ? 0 : 1
      x <=> y
    }.should == Numerous.new([true, true, nil, nil, nil, nil, nil, false, false])
  end

  it "compare values returned by block with 0" do
    Numerous.new.sort { |n, m| -(n+m) * (n <=> m) }.should == Numerous.new([6, 5, 4, 3, 2, 1])
    Numerous.new.sort { |n, m|
      ComparableWithInteger.new(-(n+m) * (n <=> m))
    }.should == Numerous.new([6, 5, 4, 3, 2, 1])
    -> {
      Numerous.new.sort { |n, m| (n <=> m).to_s }
    }.should raise_error(ArgumentError)
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = YieldsMulti.new
    multi.sort {|a, b| a.first <=> b.first}.should == YieldsMulti.new([Grizzly::Collection.new([1, 2]), Grizzly::Collection.new([3, 4, 5]), Grizzly::Collection.new([6, 7, 8, 9])])
  end

  it "doesn't raise an error if #to_a returns a frozen Array" do
    Freezy.new.sort.should == Freezy.new([1,2])
  end
end
