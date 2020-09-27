require_relative '../../../spec_helper'


describe :collection_max, shared: true do
  it "is defined on Array" do
    @subject.new([1]).method(:max).owner.should equal Array
  end

  it "returns nil with no values" do
    @subject.new([]).max.should == nil
  end

  it "returns only element in one element array" do
    @subject.new([1]).max.should == 1
  end

  it "returns largest value with multiple elements" do
    @subject.new([1,2]).max.should == 2
    @subject.new([2,1]).max.should == 2
  end

  describe "given a block with one argument" do
    it "yields in turn the last length-1 values from the array" do
      ary = []
      result = @subject.new([1,2,3,4,5]).max {|x| ary << x; x}

      ary.should == [2,3,4,5]
      result.should == 5
    end
  end
end

# From Enumerable#max, copied for better readability
describe :enumerable_collection_max, shared: true do
  before :each do
    @e_strs = @subject.new(["333", "22", "666666", "1", "55555", "1010101010"])
    @e_ints = @subject.new([333,   22,   666666,   55555, 1010101010])
  end

  it "max should return the maximum element" do
    @subject.new([18, 42]).max.should == 42
    @subject.new([2, 5, 3, 6, 1, 4]).max.should == 6
  end

  it "returns the maximum element (basics cases)" do
    @subject.new([55]).max.should == 55

    @subject.new([11,99]).max.should == 99
    @subject.new([99,11]).max.should == 99
    @subject.new([2, 33, 4, 11]).max.should == 33

    @subject.new([1,2,3,4,5]).max.should == 5
    @subject.new([5,4,3,2,1]).max.should == 5
    @subject.new([1,4,3,5,2]).max.should == 5
    @subject.new([5,5,5,5,5]).max.should == 5

    @subject.new(["aa","tt"]).max.should == "tt"
    @subject.new(["tt","aa"]).max.should == "tt"
    @subject.new(["2","33","4","11"]).max.should == "4"

    @e_strs.max.should == "666666"
    @e_ints.max.should == 1010101010
  end

  it "returns nil for an empty Enumerable" do
    @subject.new([]).max.should == nil
  end

  it "raises a NoMethodError for elements without #<=>" do
    -> do
      @subject.new([BasicObject.new, BasicObject.new]).max
    end.should raise_error(NoMethodError)
  end

  it "raises an ArgumentError for incomparable elements" do
    -> do
      @subject.new([11,"22"]).max
    end.should raise_error(ArgumentError)
    -> do
      @subject.new([11,12,22,33]).max{|a, b| nil}
    end.should raise_error(ArgumentError)
  end

  it "returns the maximum element (with block)" do
    # with a block
    @subject.new(["2","33","4","11"]).max {|a,b| a <=> b }.should == "4"
    @subject.new([ 2 , 33 , 4 , 11 ]).max {|a,b| a <=> b }.should == 33

    @subject.new(["2","33","4","11"]).max {|a,b| b <=> a }.should == "11"
    @subject.new([ 2 , 33 , 4 , 11 ]).max {|a,b| b <=> a }.should == 2

    @e_strs.max {|a,b| a.length <=> b.length }.should == "1010101010"

    @e_strs.max {|a,b| a <=> b }.should == "666666"
    @e_strs.max {|a,b| a.to_i <=> b.to_i }.should == "1010101010"

    @e_ints.max {|a,b| a <=> b }.should == 1010101010
    @e_ints.max {|a,b| a.to_s <=> b.to_s }.should == 666666
  end

  it "returns the minimum for enumerables that contain nils" do
    arr = @subject.new([nil, nil, true])
    arr.max { |a, b|
      x = a.nil? ? 1 : a ? 0 : -1
      y = b.nil? ? 1 : b ? 0 : -1
      x <=> y
    }.should == nil
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = @subject.new([[1,2], [3,4,5], [6,7,8,9]])
    multi.max.should == [6, 7, 8, 9]
  end

end

describe "Array#max" do
  before { @subject = Array }

  it_behaves_like :collection_max, :max
  it_behaves_like :enumerable_collection_max, :max
end

describe "Collection#max" do
  before { @subject = Group }

  it_behaves_like :collection_max, :max
  it_behaves_like :enumerable_collection_max, :max
end