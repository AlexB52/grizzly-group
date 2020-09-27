require_relative '../../../spec_helper'


describe :collection_min, shared: true do
  it "is defined on Array" do
    @subject.new([1]).method(:max).owner.should equal Array
  end

  it "returns nil with no values" do
    @subject.new([]).min.should == nil
  end

  it "returns only element in one element array" do
    @subject.new([1]).min.should == 1
  end

  it "returns smallest value with multiple elements" do
    @subject.new([1,2]).min.should == 1
    @subject.new([2,1]).min.should == 1
  end

  describe "given a block with one argument" do
    it "yields in turn the last length-1 values from the array" do
      ary = []
      result = @subject.new([1,2,3,4,5]).min {|x| ary << x; x}

      ary.should == [2,3,4,5]
      result.should == 1
    end
  end
end

# From Enumerable#min, copied for better readability
describe :enumerable_collection_min, shared: true do
  before :each do
    @e_strs = @subject.new(["333", "22", "666666", "1", "55555", "1010101010"])
    @e_ints = @subject.new([ 333,   22,   666666,        55555,   1010101010])
  end

  it "min should return the minimum element" do
    @subject.new([18, 42]).min.should == 18
    @subject.new([2, 5, 3, 6, 1, 4]).min.should == 1
  end

  it "returns the minimum (basic cases)" do
    @subject.new([55]).min.should == 55

    @subject.new([11,99]).min.should ==  11
    @subject.new([99,11]).min.should == 11
    @subject.new([2, 33, 4, 11]).min.should == 2

    @subject.new([1,2,3,4,5]).min.should == 1
    @subject.new([5,4,3,2,1]).min.should == 1
    @subject.new([4,1,3,5,2]).min.should == 1
    @subject.new([5,5,5,5,5]).min.should == 5

    @subject.new(["aa","tt"]).min.should == "aa"
    @subject.new(["tt","aa"]).min.should == "aa"
    @subject.new(["2","33","4","11"]).min.should == "11"

    @e_strs.min.should == "1"
    @e_ints.min.should == 22
  end

  it "returns nil for an empty Enumerable" do
    @subject.new([]).min.should be_nil
  end

  it "raises a NoMethodError for elements without #<=>" do
    -> do
      @subject.new([BasicObject.new, BasicObject.new]).min
    end.should raise_error(NoMethodError)
  end

  it "raises an ArgumentError for incomparable elements" do
    -> do
      @subject.new([11,"22"]).min
    end.should raise_error(ArgumentError)
    -> do
      @subject.new([11,12,22,33]).min{|a, b| nil}
    end.should raise_error(ArgumentError)
  end

  it "returns the minimum when using a block rule" do
    @subject.new(["2","33","4","11"]).min {|a,b| a <=> b }.should == "11"
    @subject.new([ 2 , 33 , 4 , 11 ]).min {|a,b| a <=> b }.should == 2

    @subject.new(["2","33","4","11"]).min {|a,b| b <=> a }.should == "4"
    @subject.new([ 2 , 33 , 4 , 11 ]).min {|a,b| b <=> a }.should == 33

    @subject.new([ 1, 2, 3, 4 ]).min {|a,b| 15 }.should == 1

    @subject.new([11,12,22,33]).min{|a, b| 2 }.should == 11
    @i = -2
    @subject.new([11,12,22,33]).min{|a, b| @i += 1 }.should == 12

    @e_strs.min {|a,b| a.length <=> b.length }.should == "1"

    @e_strs.min {|a,b| a <=> b }.should == "1"
    @e_strs.min {|a,b| a.to_i <=> b.to_i }.should == "1"

    @e_ints.min {|a,b| a <=> b }.should == 22
    @e_ints.min {|a,b| a.to_s <=> b.to_s }.should == 1010101010
  end

  it "returns the minimum for enumerables that contain nils" do
    arr = @subject.new([nil, nil, true])
    arr.min { |a, b|
      x = a.nil? ? -1 : a ? 0 : 1
      y = b.nil? ? -1 : b ? 0 : 1
      x <=> y
    }.should == nil
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = [[1,2], [3,4,5], [6,7,8,9]]
    multi.min.should == [1, 2]
  end

end

describe "Array#min" do
  before { @subject = Array }

  it_behaves_like :collection_min, :min
  it_behaves_like :enumerable_collection_min, :min
end

describe "Collection#min" do
  before { @subject = Group }

  it_behaves_like :collection_min, :min
  it_behaves_like :enumerable_collection_min, :min
end